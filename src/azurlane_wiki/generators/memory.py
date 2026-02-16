# -*- coding: utf-8 -*-
"""Memory/story content generator."""
import os
import re
from .base import BaseGenerator
from ..core import (
    parse_data_file, load_json_file, get_ship_name,
    parse_name_code, sanitize_filename
)


class MemoryGenerator(BaseGenerator):
    """Generator for memory/story wiki pages."""

    # Color mapping for character names
    COLOR_DICT = {
        '#a9f548': '#4eb24e',  # Green
        '#ffff4d': '#ffd000',  # Yellow
        '#ff5c5c': '#ec5d53',  # Red
        '#ffa500': '#ff9900'   # Orange
    }

    def __init__(self, config=None):
        """Initialize memory generator."""
        super().__init__(config)
        self.stories = None
        self.dungeons = None

    def generate(self, region=None):
        """Generate memory pages for specified region.

        Args:
            region: Game region (CN, JP, EN, KR, TW). Uses config default if None.
        """
        # Create a new config for this region to avoid modifying shared config
        if region:
            from ..config import Config
            config = Config(region=region)
        else:
            config = self.config

        # Load data using the appropriate config
        name_code = self._get_name_code(config)
        memory_group = parse_data_file('memory_group', config=config)
        memory_template = parse_data_file('memory_template', config=config)
        world_group = parse_data_file('world_collection_record_group', config=config)
        world_template = parse_data_file('world_collection_record_template', config=config)
        ship_statistics = parse_data_file('ship_data_statistics', config=config)
        ship_template = parse_data_file('ship_data_template', config=config)
        skin_template = parse_data_file('ship_skin_template', config=config)

        # Load stories
        story_file = 'storyjp' if config.region == 'JP' else 'story'
        self.stories = load_json_file(story_file, config)
        self.dungeons = load_json_file('dungeon', config)

        # Build groups
        groups = self._get_group(memory_group, world_group)
        self._merge_memory_template(memory_template, world_template)

        # Generate content
        groups_built = []
        for v in groups:
            groups_built.append(self._build_group(
                v, skin_template, ship_statistics, ship_template,
                memory_template, name_code
            ))

        # Write output
        region_suffix = '' if config.region == 'CN' else config.region
        output_dir = os.path.join(config.output_directory, 'memories', region_suffix)
        os.makedirs(output_dir, exist_ok=True)

        for group in groups_built:
            filename = sanitize_filename(group['title']) + '.txt'
            filepath = os.path.join(output_dir, filename)
            with open(filepath, 'w+', encoding='utf-8') as f:
                f.write(self._wiki_page(group))

    def _get_name_code(self, config=None):
        """Get name code dictionary (CN only)."""
        if config is None:
            config = self.config
        if config.region == 'CN':
            from ..core import get_name_code
            return get_name_code(config)
        return {}

    def _get_memory_group(self):
        return parse_data_file('memory_group', config=self.config)

    def _get_memory_template(self):
        return parse_data_file('memory_template', config=self.config)

    def _get_world_group(self):
        return parse_data_file('world_collection_record_group', config=self.config)

    def _get_world_template(self):
        return parse_data_file('world_collection_record_template', config=self.config)

    def _get_ship_statistics(self):
        return parse_data_file('ship_data_statistics', config=self.config)

    def _get_ship_template(self):
        return parse_data_file('ship_data_template', config=self.config)

    def _get_ship_skin_template(self):
        return parse_data_file(
            'ship_skin_template',
            file_path=os.path.join('sharecfg', 'ship_skin_template_sublist'),
            mode=1,
            config=self.config
        )

    def _get_story(self, filename, story_type=1):
        """Get story data from filename."""
        if filename.isnumeric():
            story_type = 2
        if story_type == 1:
            return self.stories[filename]
        elif story_type == 2:
            dungeon = self.dungeons[int(filename)]
            storylist = []
            if 'beginStoy' in dungeon.keys():
                storylist.append((0, dungeon['beginStoy'], -1))
            stage = dungeon['stages']
            for wave in stage[0]['waves']:
                if 'preWaves' in wave.keys():
                    prewaves = wave['preWaves']
                else:
                    prewaves = []
                if wave['triggerType'] == 3:
                    self._insert_wave(storylist, (wave['waveIndex'], wave['triggerParams']['id'], prewaves))
                elif 'spawn' in wave.keys():
                    for spawn in wave['spawn']:
                        if 'phase' in spawn.keys():
                            for p in spawn['phase']:
                                if 'story' in p.keys():
                                    self._insert_wave(storylist, (wave['waveIndex'], p['story'], prewaves))
                else:
                    self._insert_wave(storylist, (wave['waveIndex'], None, prewaves))
            output = []
            for story in storylist:
                if story[1]:
                    s = self._get_story(story[1].lower())
                    output.append(s)
            return output

    def _insert_wave(self, wavelist, wave):
        """Insert wave into storylist in correct order."""
        prewaves = wave[2].copy()
        if len(prewaves) > 0:
            for i in range(len(wavelist)):
                if wavelist[i][0] in prewaves:
                    prewaves.remove(wavelist[i][0])
                    if len(prewaves) == 0:
                        wavelist.insert(i, wave)
                        return
        wavelist.append(wave)

    def _get_group(self, memory_group, world_group):
        """Combine memory and world groups."""
        group = []
        for k, v in memory_group.items():
            group.append({'memories': v['memories'], 'title': v['title']})
        for k, v in world_group.items():
            group.append({'memories': v['child'], 'title': v['name_abbreviate']})
        return group

    def _merge_memory_template(self, memory_template, world_template):
        """Merge world template into memory template."""
        for k, v in world_template.items():
            memory_template[k] = {
                'id': v['id'],
                'type': 1,
                'title': v['name'],
                'story': v['story']
            }

    def _get_memory(self, memory_id, memory_template):
        """Get memory data by ID."""
        output = {}
        for k, v in memory_template.items():
            if v['id'] == memory_id:
                output['title'] = v['title']
                story = v['story'].lower()
                output['type'] = v['type']
        try:
            output['story'] = self._get_story(story, output['type'])
        except:
            print(output)
            print(self.stories.keys())
            raise
        return output

    def _sanitize_memory(self, memory, skin_template, ship_statistics, ship_template, name_code):
        """Process raw memory data into structured format."""
        output = {
            'title': parse_name_code(memory['title'], name_code, af=True),
            'memory': []
        }

        if isinstance(memory['story'], list):
            temp_memory = {'title': memory['title']}
            for story in memory['story']:
                temp_memory['story'] = story
                seg_memory = self._sanitize_memory(
                    temp_memory, skin_template, ship_statistics, ship_template, name_code
                )
                for m in seg_memory['memory']:
                    output['memory'].append(m)
                output['memory'].append({
                    'type': 'break',
                    'words': None,
                    'name': None,
                    'actor': None,
                    'color': None,
                    'option': None
                })
            output['memory'] = output['memory'][:-1]
            return output

        if "scripts" not in memory['story'].keys():
            return output

        scripts = memory['story']['scripts']
        if isinstance(scripts, dict):
            scripts = scripts.values()

        for script in scripts:
            slide_data = self._process_script(script, skin_template, ship_statistics, name_code)
            if slide_data:
                output['memory'].append(slide_data)

        return output

    def _process_script(self, script, skin_template, ship_statistics, name_code):
        """Process a single script entry."""
        words = ''
        slide_type = None
        name = ''
        actor = None
        color = None
        option = None

        if isinstance(script, dict) and 'sequence' in script.keys():
            if isinstance(script['sequence'], dict):
                script['sequence'] = script['sequence'].values()
            for s in script['sequence']:
                words += s[0] + '\n'
            words = words[:-1]
            slide_type = 'sequence'
            if len(words) == 0:
                return None

        elif isinstance(script, dict) and 'say' in script.keys():
            words = script['say']
            actor = script.get('actor', None)
            color = script['nameColor'][:7].lower() if 'nameColor' in script.keys() else None

            if 'options' in script.keys():
                option = {'options': []}
                options = script['options']
                if isinstance(options, dict):
                    options = options.values()
                for o in options:
                    flag = o.get('flag', '')
                    option['options'].append({
                        'flag': flag,
                        'content': parse_name_code(o['content'], name_code, af=True)
                    })

            if 'optionFlag' in script.keys():
                if not option:
                    option = {}
                option['optionFlag'] = script['optionFlag']

            if 'actorName' in script.keys():
                name = script['actorName']
            elif actor and actor > 0:
                try:
                    name = get_ship_name(actor, skin_template, ship_statistics)
                    if name is None:
                        name = ''
                except:
                    name = str(actor)
                    print(f'未找到actor{actor}名称')
            elif actor == 0:
                name = "指挥官"
            else:
                name = ''
            slide_type = 'say'
        else:
            return None

        words = re.sub(r'<.*?>', '', words)
        words = parse_name_code(words, name_code, af=True)
        name = parse_name_code(name, name_code, af=True)

        return {
            'type': slide_type,
            'words': words,
            'name': name,
            'actor': actor,
            'color': color,
            'option': option
        }

    def _build_group(self, group, skin_template, ship_statistics, ship_template, memory_template, name_code):
        """Build a complete group with all memories."""
        output = {
            'title': parse_name_code(group['title'], name_code),
            'memories': []
        }
        try:
            for memory_id in group['memories']:
                memory = self._get_memory(memory_id, memory_template)
                if memory:
                    memory = self._sanitize_memory(
                        memory, skin_template, ship_statistics, ship_template, name_code
                    )
                else:
                    continue
                output['memories'].append(memory)
        except:
            print(str(memory))
            raise
        return output

    def _wiki_page(self, group):
        """Generate wiki page for a group."""
        output = '== ' + group['title'] + ' ==\n{{折叠面板|开始}}\n'
        index = 1
        for memory in group['memories']:
            output += self._wiki_paragraph(memory, index)
            index += 1
        output += '{{折叠面板|结束}}\n'
        return output.replace('\\n', '\n')

    def _wiki_paragraph(self, memory, index):
        """Generate wiki paragraph for a memory."""
        output = f"{{{{折叠面板|标题={memory['title']}|选项={index}|主框=1|样式=primary|展开=是}}}}\n"
        last_actor = None
        last_option = None
        for slide in memory['memory']:
            output += self._wiki_slide(slide, last_actor, last_option)
            last_actor = slide['name']
            last_option = None
            if slide['option']:
                if 'optionFlag' in slide['option'].keys():
                    last_option = slide['option']['optionFlag']
                elif 'options' in slide['option'].keys():
                    last_option = 0
        output += '{{折叠面板|内容结束}}\n\n'
        return output

    def _wiki_slide(self, slide, last_actor, last_option):
        """Generate wiki markup for a single slide."""
        output = ''
        if slide['type'] == 'break':
            return '<br>\n'

        this_option = None
        if slide['option']:
            if 'optionFlag' in slide['option'].keys():
                this_option = slide['option']['optionFlag']
            elif 'options' in slide['option'].keys():
                this_option = 0

        if this_option != 0 and this_option != last_option:
            name = slide['name']
        elif slide['name'] == last_actor:
            name = None
        else:
            name = slide['name']

        if name is not None:
            if name == "指挥官":
                output += '<span style="color:#3498DB;" class="shikikanname">指挥官</span>：'
            elif len(name) > 0:
                if slide['color']:
                    output += '<span style="color:' + self._replace_color(slide['color']) + ';">' + name + '：</span>'
                else:
                    output += name + '：'
            output += '<br>\n'

        if slide['option'] and 'optionFlag' in slide['option'].keys():
            output += "'''''<span style=\"color:black;\">（选择项" + str(slide['option']['optionFlag']) + "）</span>'''''"

        output += self._nowiki(slide['words']).replace('\n', '<br>\n') + '<br>\n'

        if slide['option'] and 'options' in slide['option'].keys():
            output += '<br>\n'
            for option in slide['option']['options']:
                output += "'''''<span style=\"color:black;\">选择项" + str(option['flag']) + "："
                output += self._nowiki(option['content']) + "</span>'''''<br>\n"

        return output

    def _nowiki(self, text):
        """Wrap consecutive tildes in nowiki tags."""
        return re.sub(r'(~{3,})', r'<nowiki>\1</nowiki>', text)

    def _replace_color(self, color):
        """Replace color codes with wiki-friendly versions."""
        return self.COLOR_DICT.get(color, color)
