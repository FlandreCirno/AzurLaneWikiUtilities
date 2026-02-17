local p = {}

--------------------------------------------------
--	公开函数
--------------------------------------------------

p['装备ID'] = function(frame)
	local name = frame.args['装备']
	local tech = string.upper(string.sub(name, -2))
	if tech == 'T0' then
		tech = 0
	elseif tech == 'T1' then
		tech = 1
	elseif tech == 'T2' then
		tech = 2
	elseif tech == 'T3' then
		tech = 3
	else
		tech = -1
	end
	if tech ~= -1 then
		name = string.sub(name, 0, -3)
	end
	for _, item in ipairs(p.equip_data) do
		if item.name == name then
			local id = item.id
			for _, sub in ipairs(item.sub_equips) do
				if sub.tech == tech then
					id = sub.id
				end
			end
			return id
		end
	end
	return 99999
end

p.equip_data = {
{
	id = 2,
	name = "序章重巡-萨福克（瞄准型）",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2	};
	}
};
{
	id = 3,
	name = "序章重巡-诺福克（散射型、肉盾）",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 3	};
	}
};
{
	id = 4,
	name = "序章战巡-胡德",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 5, id = 4	};
	}
};
{
	id = 5,
	name = "序章战列-威尔士亲王",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 5	};
	}
};
{
	id = 6,
	name = "序章重巡-萨福克三联533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 6	};
	}
};
{
	id = 7,
	name = "序章重巡-诺福克四联533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 7	};
	}
};
{
	id = 8,
	name = "序章重巡-欧根亲王（瞄准型）",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 8	};
	}
};
{
	id = 20,
	name = "U556关卡单发鱼雷-弹药2",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 20	};
	}
};
{
	id = 21,
	name = "U556关卡单发鱼雷-弹药4",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 21	};
	}
};
{
	id = 22,
	name = "U556关卡单发鱼雷-弹药6",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 22	};
	}
};
{
	id = 23,
	name = "J-10机炮 FC-1机炮 双管",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 23	};
	}
};
{
	id = 24,
	name = "J-15机炮 单管",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 24	};
	}
};
{
	id = 25,
	name = "中飞导弹1",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 25	};
	}
};
{
	id = 26,
	name = "中飞导弹2",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 26	};
	}
};
{
	id = 27,
	name = "J-20 普攻导弹",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 27	};
	}
};
{
	id = 28,
	name = "J-20 手动导弹",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 28	};
	}
};
{
	id = 98,
	name = "可打断测试武器",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 98	};
	}
};
{
	id = 99,
	name = "测试鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 99	};
	}
};
{
	id = 100,
	name = "默认驱逐武器",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 100	};
	}
};
{
	id = 101,
	name = "默认轻巡武器",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 101	};
	}
};
{
	id = 102,
	name = "默认重巡武器",
	type = 3,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 102	};
	}
};
{
	id = 103,
	name = "默认战列武器",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 103	};
	}
};
{
	id = 104,
	name = "默认防空炮",
	type = 6,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 104	};
	}
};
{
	id = 105,
	name = "默认双联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 105	};
	}
};
{
	id = 106,
	name = "默认三联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 106	};
	}
};
{
	id = 107,
	name = "默认四联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 107	};
	}
};
{
	id = 108,
	name = "默认五联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 108	};
	}
};
{
	id = 109,
	name = "默认白鹰战斗机",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 109	};
	}
};
{
	id = 110,
	name = "默认白鹰鱼雷机",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 110	};
	}
};
{
	id = 111,
	name = "默认白鹰轰炸机",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 111	};
	}
};
{
	id = 113,
	name = "默认皇家战斗机",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 113	};
	}
};
{
	id = 114,
	name = "默认皇家鱼雷机",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 114	};
	}
};
{
	id = 115,
	name = "默认皇家轰炸机",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 115	};
	}
};
{
	id = 117,
	name = "默认重樱战斗机",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 117	};
	}
};
{
	id = 118,
	name = "默认重樱鱼雷机",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 118	};
	}
};
{
	id = 119,
	name = "默认重樱轰炸机",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 119	};
	}
};
{
	id = 121,
	name = "默认铁血战斗机",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 121	};
	}
};
{
	id = 122,
	name = "默认铁血鱼雷机",
	type = 8,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 122	};
	}
};
{
	id = 123,
	name = "默认铁血轰炸机",
	type = 9,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 123	};
	}
};
{
	id = 125,
	name = "默认鸢尾战斗机",
	type = 7,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 125	};
	}
};
{
	id = 126,
	name = "默认鸢尾鱼雷机",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 126	};
	}
};
{
	id = 127,
	name = "默认鸢尾轰炸机",
	type = 9,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 127	};
	}
};
{
	id = 140,
	name = "默认潜艇鱼雷",
	type = 13,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 140	};
	}
};
{
	id = 141,
	name = "默认深水炸弹_驱逐",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 141	};
	}
};
{
	id = 144,
	name = "默认潜母水侦",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 144	};
	}
};
{
	id = 147,
	name = "默认深水炸弹_轻巡",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 147	};
	}
};
{
	id = 148,
	name = "默认撒丁战斗机",
	type = 7,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 148	};
	}
};
{
	id = 149,
	name = "默认撒丁鱼雷机",
	type = 8,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 149	};
	}
};
{
	id = 150,
	name = "默认撒丁轰炸机",
	type = 9,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 150	};
	}
};
{
	id = 152,
	name = "默认鸢尾水侦",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 152	};
	}
};
{
	id = 153,
	name = "默认北联战斗机",
	type = 7,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 153	};
	}
};
{
	id = 154,
	name = "默认北联鱼雷机",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 154	};
	}
};
{
	id = 155,
	name = "默认北联轰炸机",
	type = 9,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 155	};
	}
};
{
	id = 158,
	name = "默认风帆主力武器",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 158	};
	}
};
{
	id = 190,
	name = "测试远程 防空炮",
	type = 6,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 190	};
	}
};
{
	id = 201,
	name = "白鹰雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 202	};
		{	tech = 0, rarity = 0, id = 203	};
		{	tech = 1, rarity = 1, id = 201	};
	}
};
{
	id = 204,
	name = "白鹰雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 204	};
	}
};
{
	id = 211,
	name = "皇家雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 212	};
		{	tech = 0, rarity = 0, id = 213	};
		{	tech = 1, rarity = 1, id = 211	};
	}
};
{
	id = 214,
	name = "皇家雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 214	};
	}
};
{
	id = 215,
	name = "皇家雷击轻巡副炮T4（德雷克模拟关卡用）",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 215	};
	}
};
{
	id = 221,
	name = "重樱雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 222	};
		{	tech = 0, rarity = 0, id = 223	};
		{	tech = 1, rarity = 1, id = 221	};
	}
};
{
	id = 224,
	name = "重樱雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 224	};
	}
};
{
	id = 231,
	name = "铁血雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 232	};
		{	tech = 0, rarity = 0, id = 233	};
		{	tech = 1, rarity = 1, id = 231	};
	}
};
{
	id = 234,
	name = "铁血雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 234	};
	}
};
{
	id = 251,
	name = "撒丁雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 252	};
		{	tech = 0, rarity = 0, id = 253	};
		{	tech = 1, rarity = 1, id = 251	};
	}
};
{
	id = 254,
	name = "撒丁雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 254	};
	}
};
{
	id = 261,
	name = "北方联合雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 262	};
		{	tech = 0, rarity = 0, id = 263	};
		{	tech = 1, rarity = 1, id = 261	};
	}
};
{
	id = 264,
	name = "北方联合雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 264	};
	}
};
{
	id = 271,
	name = "鸢尾雷击轻巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 272	};
		{	tech = 0, rarity = 0, id = 273	};
		{	tech = 1, rarity = 1, id = 271	};
	}
};
{
	id = 274,
	name = "鸢尾雷击轻巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 274	};
	}
};
{
	id = 301,
	name = "白鹰雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 302	};
		{	tech = 0, rarity = 0, id = 303	};
		{	tech = 1, rarity = 1, id = 301	};
	}
};
{
	id = 304,
	name = "白鹰雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 304	};
	}
};
{
	id = 311,
	name = "皇家雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 312	};
		{	tech = 0, rarity = 0, id = 313	};
		{	tech = 1, rarity = 1, id = 311	};
	}
};
{
	id = 314,
	name = "皇家雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 314	};
	}
};
{
	id = 321,
	name = "重樱雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 322	};
		{	tech = 0, rarity = 0, id = 323	};
		{	tech = 1, rarity = 1, id = 321	};
	}
};
{
	id = 324,
	name = "重樱雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 324	};
	}
};
{
	id = 331,
	name = "铁血雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 332	};
		{	tech = 0, rarity = 0, id = 333	};
		{	tech = 1, rarity = 1, id = 331	};
	}
};
{
	id = 334,
	name = "铁血雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 334	};
	}
};
{
	id = 351,
	name = "撒丁雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 352	};
		{	tech = 0, rarity = 0, id = 353	};
		{	tech = 1, rarity = 1, id = 351	};
	}
};
{
	id = 354,
	name = "撒丁雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 354	};
	}
};
{
	id = 371,
	name = "鸢尾雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 372	};
		{	tech = 0, rarity = 0, id = 373	};
		{	tech = 1, rarity = 1, id = 371	};
	}
};
{
	id = 374,
	name = "鸢尾雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 374	};
	}
};
{
	id = 391,
	name = "北联雷击重巡副炮",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 392	};
		{	tech = 0, rarity = 0, id = 393	};
		{	tech = 1, rarity = 1, id = 391	};
	}
};
{
	id = 394,
	name = "北联雷击重巡副炮T4",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 394	};
	}
};
{
	id = 430,
	name = "喀琅施塔得自带副炮",
	type = 1,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 430	};
	}
};
{
	id = 431,
	name = "双联装128mmSKC41高平两用炮（奥丁副炮）",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 431	};
	}
};
{
	id = 432,
	name = "三联装SKC25式150mm主炮（奥丁副炮）",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 432	};
	}
};
{
	id = 433,
	name = "四联装533mm磁性鱼雷（模拟展示用）",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 433	};
	}
};
{
	id = 434,
	name = "试作型三联装234mm主炮（模拟展示用）",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 434	};
	}
};
{
	id = 435,
	name = "皇家雷击轻巡副炮T4（模拟展示用）",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 435	};
	}
};
{
	id = 436,
	name = "P1突破后自带150mm副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 436	};
	}
};
{
	id = 437,
	name = "应瑞肇和自带防空炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 437	};
	}
};
{
	id = 438,
	name = "埃吉尔自带强化型副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 438	};
	}
};
{
	id = 439,
	name = "奈美子自带征战巨坦副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 439	};
	}
};
{
	id = 440,
	name = "征战巨坦自带主炮-类152MK5",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 440	};
	}
};
{
	id = 441,
	name = "爆裂钻孔机自带鱼雷-类四联装533mm磁雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 441	};
	}
};
{
	id = 442,
	name = "苍穹喷射机自带防空炮-类六联博福斯",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 442	};
	}
};
{
	id = 446,
	name = "格奈META特殊副炮",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 446	};
	}
};
{
	id = 447,
	name = "P2突破后自带150mm副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 447	};
	}
};
{
	id = 448,
	name = "单联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 448	};
	}
};
{
	id = 449,
	name = "展示用双联主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 449	};
	}
};
{
	id = 450,
	name = "征战巨坦自带主炮-类152MK5+3",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 450	};
	}
};
{
	id = 451,
	name = "征战巨坦自带主炮-类152MK5+5",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 451	};
	}
};
{
	id = 452,
	name = "征战巨坦自带主炮-类152MK5+8",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 452	};
	}
};
{
	id = 453,
	name = "征战巨坦自带主炮-类152MK5+11",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 453	};
	}
};
{
	id = 454,
	name = "征战巨坦自带主炮-类152MK5+13",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 454	};
	}
};
{
	id = 455,
	name = "钻孔机自带鱼雷-类四联磁+3",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 455	};
	}
};
{
	id = 456,
	name = "钻孔机自带鱼雷-类四联磁+5",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 456	};
	}
};
{
	id = 457,
	name = "钻孔机自带鱼雷-类四联磁+8",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 457	};
	}
};
{
	id = 458,
	name = "钻孔机自带鱼雷-类四联磁+11",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 458	};
	}
};
{
	id = 459,
	name = "钻孔机自带鱼雷-类四联磁+13",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 459	};
	}
};
{
	id = 460,
	name = "VIT自带防空炮-类六联博福斯+3",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 460	};
	}
};
{
	id = 461,
	name = "VIT自带防空炮-类六联博福斯+5",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 461	};
	}
};
{
	id = 462,
	name = "VIT自带防空炮-类六联博福斯+8",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 462	};
	}
};
{
	id = 463,
	name = "VIT自带防空炮-类六联博福斯+11",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 463	};
	}
};
{
	id = 464,
	name = "VIT自带防空炮-类六联博福斯+13",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 464	};
	}
};
{
	id = 465,
	name = "布雷斯特后向副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 465	};
	}
};
{
	id = 466,
	name = "火球替换鱼雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 466	};
	}
};
{
	id = 467,
	name = "雷球替换防空",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 467	};
	}
};
{
	id = 468,
	name = "哈曼II自带刺猬弹",
	type = 14,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 468	};
	}
};
{
	id = 469,
	name = "摩耶特殊兵装专属特殊防空炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 469	};
	}
};
{
	id = 470,
	name = "英雄满破强化深弹",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 470	};
	}
};
{
	id = 471,
	name = "革律翁用双联装副炮",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 471	};
	}
};
{
	id = 472,
	name = "150mm五式炮自带防空炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 472	};
	}
};
{
	id = 478,
	name = "狂战帝王古立特自带主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 478	};
	}
};
{
	id = 479,
	name = "狂战帝王古立特自带鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 479	};
	}
};
{
	id = 486,
	name = "投影「罗德尼」短距近防",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 486	};
	}
};
{
	id = 491,
	name = "纳希莫夫 自带副炮",
	type = 1,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 5, id = 491	};
	}
};
{
	id = 492,
	name = "埃尔德里奇改造 自带刺猬弹（强化）",
	type = 14,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 492	};
	}
};
{
	id = 500,
	name = "小海狸中队队徽",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 500	};
	}
};
{
	id = 520,
	name = "珍珠之泪",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 520	};
	}
};
{
	id = 540,
	name = "治愈系猫爪",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 540	};
	}
};
{
	id = 560,
	name = "“宁海号”水上侦察机",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 560	};
	}
};
{
	id = 580,
	name = "九一式穿甲弹",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 580	};
	}
};
{
	id = 600,
	name = "一式穿甲弹",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 600	};
	}
};
{
	id = 620,
	name = "超重弹",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 620	};
	}
};
{
	id = 640,
	name = "Z旗",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 640	};
	}
};
{
	id = 660,
	name = "100/150号航空燃油",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 660	};
	}
};
{
	id = 680,
	name = "归航信标",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 680	};
	}
};
{
	id = 700,
	name = "九八式射击延迟装置",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 700	};
	}
};
{
	id = 720,
	name = "约定的证明",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 720	};
	}
};
{
	id = 740,
	name = "Fl-282直升机",
	type = 17,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 740	};
	}
};
{
	id = 760,
	name = "侦察报告·纽约近海",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 760	};
	}
};
{
	id = 780,
	name = "机密文件·极地海峡",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 780	};
	}
};
{
	id = 800,
	name = "艇壳改良设计案",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 2, rarity = 4, id = 800	};
	}
};
{
	id = 820,
	name = "开拓者奖章",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 820	};
	}
};
{
	id = 840,
	name = "白鹰精英损管",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 840	};
	}
};
{
	id = 860,
	name = "华盛顿海军条约",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 860	};
	}
};
{
	id = 880,
	name = "纳尔逊的旗语",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 880	};
	}
};
{
	id = 940,
	name = "作战报告：AF",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 940	};
	}
};
{
	id = 960,
	name = "FuMO 25",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 960	};
	}
};
{
	id = 980,
	name = "机密文件·日志残卷",
	type = 10,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 980	};
	}
};
{
	id = 1000,
	name = "舰艇维修设备",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 1000	};
		{	tech = 2, rarity = 4, id = 1020	};
		{	tech = 3, rarity = 5, id = 1040	};
	}
};
{
	id = 1060,
	name = "6CRH穿甲弹",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 1060	};
	}
};
{
	id = 1100,
	name = "对空雷达",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 1100	};
		{	tech = 2, rarity = 3, id = 1120	};
		{	tech = 3, rarity = 4, id = 1140	};
	}
};
{
	id = 1160,
	name = "高性能对空雷达",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 1160	};
	}
};
{
	id = 1200,
	name = "火控雷达",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 1200	};
		{	tech = 2, rarity = 3, id = 1220	};
		{	tech = 3, rarity = 4, id = 1240	};
	}
};
{
	id = 1260,
	name = "高性能火控雷达",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 1260	};
	}
};
{
	id = 1300,
	name = "防鱼雷隔舱",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 1300	};
		{	tech = 2, rarity = 3, id = 1320	};
		{	tech = 3, rarity = 4, id = 1340	};
	}
};
{
	id = 1400,
	name = "液压弹射装置",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 1400	};
		{	tech = 2, rarity = 4, id = 1420	};
		{	tech = 3, rarity = 5, id = 1440	};
	}
};
{
	id = 1500,
	name = "SG雷达",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 1500	};
		{	tech = 2, rarity = 4, id = 1520	};
		{	tech = 3, rarity = 5, id = 1540	};
	}
};
{
	id = 1600,
	name = "电动扬弹机",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 1600	};
		{	tech = 2, rarity = 2, id = 1620	};
		{	tech = 3, rarity = 3, id = 1640	};
	}
};
{
	id = 1700,
	name = "液压舵机",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 1700	};
		{	tech = 2, rarity = 2, id = 1720	};
		{	tech = 3, rarity = 3, id = 1740	};
	}
};
{
	id = 1760,
	name = "高性能舵机",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 1760	};
	}
};
{
	id = 1800,
	name = "改良锅炉",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 1800	};
		{	tech = 2, rarity = 3, id = 1820	};
		{	tech = 3, rarity = 4, id = 1840	};
	}
};
{
	id = 1900,
	name = "海军迷彩",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 1900	};
		{	tech = 2, rarity = 2, id = 1920	};
		{	tech = 3, rarity = 3, id = 1940	};
	}
};
{
	id = 1960,
	name = "海魂迷彩",
	type = 10,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 1960	};
	}
};
{
	id = 2000,
	name = "燃油滤清器",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2000	};
		{	tech = 2, rarity = 3, id = 2020	};
		{	tech = 3, rarity = 4, id = 2040	};
	}
};
{
	id = 2100,
	name = "航空副油箱",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2100	};
		{	tech = 2, rarity = 3, id = 2120	};
		{	tech = 3, rarity = 4, id = 2140	};
	}
};
{
	id = 2200,
	name = "链式装弹机",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2200	};
		{	tech = 2, rarity = 3, id = 2220	};
		{	tech = 3, rarity = 4, id = 2240	};
	}
};
{
	id = 2300,
	name = "陀螺仪",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2300	};
		{	tech = 2, rarity = 3, id = 2320	};
		{	tech = 3, rarity = 4, id = 2340	};
	}
};
{
	id = 2400,
	name = "维修工具",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2400	};
		{	tech = 2, rarity = 3, id = 2420	};
		{	tech = 3, rarity = 4, id = 2440	};
	}
};
{
	id = 2500,
	name = "灭火器",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 2500	};
		{	tech = 2, rarity = 2, id = 2520	};
		{	tech = 3, rarity = 3, id = 2540	};
	}
};
{
	id = 2600,
	name = "九三式纯氧鱼雷",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 4, id = 2600	};
		{	tech = 2, rarity = 5, id = 2620	};
		{	tech = 3, rarity = 6, id = 2640	};
	}
};
{
	id = 2700,
	name = "533mm磁性鱼雷（水面舰艇用）",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 2700	};
		{	tech = 2, rarity = 4, id = 2720	};
		{	tech = 3, rarity = 5, id = 2740	};
	}
};
{
	id = 2800,
	name = "94式高射装置",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 2800	};
	}
};
{
	id = 2900,
	name = "基础声呐",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 2900	};
		{	tech = 2, rarity = 3, id = 2920	};
		{	tech = 3, rarity = 4, id = 2940	};
	}
};
{
	id = 3000,
	name = "改良声呐",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 3000	};
		{	tech = 2, rarity = 4, id = 3020	};
		{	tech = 3, rarity = 5, id = 3040	};
	}
};
{
	id = 3100,
	name = "高压氧气瓶",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3100	};
	}
};
{
	id = 3120,
	name = "改良型水下进气管",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3120	};
	}
};
{
	id = 3140,
	name = "改良蓄电池阵列",
	type = 10,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3140	};
	}
};
{
	id = 3200,
	name = "VH装甲钢板",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3200	};
	}
};
{
	id = 3220,
	name = "VC装甲钢板",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3220	};
	}
};
{
	id = 3300,
	name = "四神之印",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3300	};
	}
};
{
	id = 3400,
	name = "“九四式40厘米炮”部件",
	type = 18,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3400	};
	}
};
{
	id = 3500,
	name = "兵装补给（航空）",
	type = 18,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3500	};
	}
};
{
	id = 3520,
	name = "兵装补给（中小口径武器）",
	type = 18,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3520	};
	}
};
{
	id = 3540,
	name = "兵装补给（鱼雷）",
	type = 18,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3540	};
	}
};
{
	id = 3560,
	name = "破损的演讲稿",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3560	};
	}
};
{
	id = 3580,
	name = "海军部火控台",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 3580	};
	}
};
{
	id = 3600,
	name = "撒丁的邀请函",
	type = 10,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3600	};
	}
};
{
	id = 3620,
	name = "结界通行凭证",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3620	};
	}
};
{
	id = 3640,
	name = "阿尔比恩的报告书",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3640	};
	}
};
{
	id = 3660,
	name = "小王冠",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3660	};
	}
};
{
	id = 3680,
	name = "12磅长管炮",
	type = 1,
	nationality = 96,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 3680	};
		{	tech = 2, rarity = 4, id = 3700	};
		{	tech = 3, rarity = 5, id = 3720	};
	}
};
{
	id = 3740,
	name = "球形实心弹",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3740	};
	}
};
{
	id = 3760,
	name = "帆索组件",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3760	};
	}
};
{
	id = 3780,
	name = "雪顶之梦",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3780	};
	}
};
{
	id = 3800,
	name = "梅之语",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3800	};
	}
};
{
	id = 3820,
	name = "戊型水上机",
	type = 18,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3820	};
	}
};
{
	id = 3840,
	name = "“妖精魔法”海报",
	type = 10,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3840	};
	}
};
{
	id = 3860,
	name = "女王的日程表（绝密）",
	type = 10,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3860	};
	}
};
{
	id = 3880,
	name = "作战报告·极地风暴",
	type = 10,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3880	};
	}
};
{
	id = 3900,
	name = "「神石样本」研究笔记",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3900	};
	}
};
{
	id = 3920,
	name = "绿洲无液气压计",
	type = 10,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3920	};
	}
};
{
	id = 3940,
	name = "航空整备小组",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3940	};
	}
};
{
	id = 3960,
	name = "博览会纪念票",
	type = 10,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3960	};
	}
};
{
	id = 3980,
	name = "对抗模拟指令",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 3980	};
	}
};
{
	id = 4000,
	name = "基础深弹投射器",
	type = 14,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 4000	};
		{	tech = 2, rarity = 2, id = 4020	};
		{	tech = 3, rarity = 3, id = 4040	};
	}
};
{
	id = 4100,
	name = "改良深弹投射器",
	type = 14,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 4100	};
		{	tech = 2, rarity = 3, id = 4120	};
		{	tech = 3, rarity = 4, id = 4140	};
	}
};
{
	id = 4200,
	name = "剑鱼Mark II-ASV(反潜)",
	type = 15,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 4200	};
		{	tech = 2, rarity = 3, id = 4220	};
		{	tech = 3, rarity = 4, id = 4240	};
	}
};
{
	id = 4260,
	name = "塘鹅",
	type = 15,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 4260	};
	}
};
{
	id = 4300,
	name = "TBM-3复仇者(反潜)",
	type = 15,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 4300	};
		{	tech = 2, rarity = 3, id = 4320	};
		{	tech = 3, rarity = 4, id = 4340	};
	}
};
{
	id = 4360,
	name = "TBM复仇者(VT-51中队)",
	type = 15,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 4360	};
	}
};
{
	id = 5000,
	name = "三联装533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 5000	};
		{	tech = 2, rarity = 2, id = 5020	};
		{	tech = 3, rarity = 3, id = 5040	};
	}
};
{
	id = 5100,
	name = "四联装533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 5100	};
		{	tech = 2, rarity = 3, id = 5120	};
		{	tech = 3, rarity = 4, id = 5140	};
	}
};
{
	id = 5200,
	name = "五联装533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 5200	};
		{	tech = 2, rarity = 4, id = 5220	};
		{	tech = 3, rarity = 5, id = 5240	};
	}
};
{
	id = 5300,
	name = "双联装550mm鱼雷",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 5300	};
		{	tech = 2, rarity = 2, id = 5320	};
		{	tech = 3, rarity = 3, id = 5340	};
	}
};
{
	id = 5400,
	name = "三联装550mm鱼雷",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 5400	};
		{	tech = 2, rarity = 3, id = 5420	};
		{	tech = 3, rarity = 4, id = 5440	};
	}
};
{
	id = 5500,
	name = "潜艇用550mm24V鱼雷",
	type = 13,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 5500	};
		{	tech = 2, rarity = 3, id = 5520	};
		{	tech = 3, rarity = 4, id = 5540	};
	}
};
{
	id = 5600,
	name = "四联装550mm鱼雷",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 5600	};
	}
};
{
	id = 5620,
	name = "四联装550mm鱼雷（弹药调整）",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 5620	};
	}
};
{
	id = 5640,
	name = "四联装550mm鱼雷改（弹药调整）",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 5640	};
	}
};
{
	id = 5660,
	name = "550mm鱼雷组（三联装+双联装）",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 5660	};
	}
};
{
	id = 6000,
	name = "12.7mm防空机枪",
	type = 6,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 6000	};
		{	tech = 2, rarity = 2, id = 6020	};
		{	tech = 3, rarity = 3, id = 6040	};
	}
};
{
	id = 6100,
	name = "双联装100mm高炮",
	type = 6,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 6100	};
		{	tech = 2, rarity = 2, id = 6120	};
		{	tech = 3, rarity = 3, id = 6140	};
	}
};
{
	id = 7000,
	name = "单装152mm主炮",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 7000	};
		{	tech = 2, rarity = 2, id = 7020	};
		{	tech = 3, rarity = 3, id = 7040	};
	}
};
{
	id = 7100,
	name = "单装150mm主炮",
	type = 2,
	nationality = 5,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 7100	};
		{	tech = 2, rarity = 2, id = 7120	};
		{	tech = 3, rarity = 3, id = 7140	};
	}
};
{
	id = 7200,
	name = "130mm单装炮",
	type = 1,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 7200	};
		{	tech = 2, rarity = 3, id = 7220	};
		{	tech = 3, rarity = 4, id = 7240	};
	}
};
{
	id = 7300,
	name = "试作型三联装203mm舰炮",
	type = 3,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 7300	};
	}
};
{
	id = 7320,
	name = "四联装130mm副炮Mle1932",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 7320	};
	}
};
{
	id = 7340,
	name = "双联装203mm主炮Mle1924(潜艇用)",
	type = 3,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 7340	};
	}
};
{
	id = 11000,
	name = "76mm火炮",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 11000	};
		{	tech = 2, rarity = 2, id = 11020	};
		{	tech = 3, rarity = 3, id = 11040	};
	}
};
{
	id = 11060,
	name = "127mm单装炮早期型",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 11060	};
	}
};
{
	id = 11100,
	name = "127mm单装炮",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 11100	};
		{	tech = 2, rarity = 3, id = 11120	};
		{	tech = 3, rarity = 4, id = 11140	};
	}
};
{
	id = 11160,
	name = "双联装127mm副炮",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 11160	};
	}
};
{
	id = 11200,
	name = "双联装127mm高平两用炮Mk12",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 11200	};
		{	tech = 2, rarity = 4, id = 11220	};
		{	tech = 3, rarity = 5, id = 11240	};
	}
};
{
	id = 11260,
	name = "试作型双联装137mm高平两用炮Mk1",
	type = 1,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 11260	};
	}
};
{
	id = 12000,
	name = "双联152mm主炮",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 12000	};
		{	tech = 2, rarity = 2, id = 12020	};
		{	tech = 3, rarity = 3, id = 12040	};
	}
};
{
	id = 12060,
	name = "双联152mm主炮Mk15",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 12060	};
	}
};
{
	id = 12100,
	name = "三联装152mm主炮",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 12100	};
		{	tech = 1, rarity = 2, id = 22200	};
		{	tech = 2, rarity = 3, id = 12120	};
		{	tech = 2, rarity = 3, id = 22220	};
		{	tech = 3, rarity = 4, id = 12140	};
		{	tech = 3, rarity = 4, id = 22240	};
	}
};
{
	id = 12160,
	name = "三联装152mm主炮Mk16",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 12160	};
	}
};
{
	id = 12200,
	name = "试作型三联装152mm高平两用炮Mk17",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 12200	};
	}
};
{
	id = 13000,
	name = "三联装203mm主炮",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 13000	};
		{	tech = 2, rarity = 2, id = 13020	};
		{	tech = 3, rarity = 3, id = 13040	};
	}
};
{
	id = 13060,
	name = "三联装203mm主炮Mk13",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 13060	};
	}
};
{
	id = 13080,
	name = "三联装203mm主炮Mk14",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 13080	};
	}
};
{
	id = 13100,
	name = "三联装203mm主炮改进型",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 13100	};
		{	tech = 2, rarity = 3, id = 13120	};
		{	tech = 3, rarity = 4, id = 13140	};
	}
};
{
	id = 13160,
	name = "三联装203mm主炮Mk15",
	type = 3,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 13160	};
	}
};
{
	id = 13180,
	name = "三联装305mm主炮Mk8",
	type = 11,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 13180	};
		{	tech = 1, rarity = 3, id = 14000	};
		{	tech = 2, rarity = 4, id = 14020	};
		{	tech = 3, rarity = 5, id = 14040	};
	}
};
{
	id = 14100,
	name = "三联装356mm主炮",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 14100	};
		{	tech = 2, rarity = 2, id = 14120	};
		{	tech = 3, rarity = 3, id = 14140	};
	}
};
{
	id = 14160,
	name = "试作型四联装356mm主炮MkB",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 14160	};
	}
};
{
	id = 14180,
	name = "双联装406mm主炮Mk1",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 14180	};
	}
};
{
	id = 14200,
	name = "双联装406mm主炮Mk5",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 14200	};
		{	tech = 2, rarity = 3, id = 14220	};
		{	tech = 3, rarity = 4, id = 14240	};
	}
};
{
	id = 14260,
	name = "双联装406mm主炮Mk8",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 14260	};
	}
};
{
	id = 14300,
	name = "三联装406mm主炮Mk6",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 14300	};
		{	tech = 2, rarity = 3, id = 14320	};
		{	tech = 3, rarity = 4, id = 14340	};
	}
};
{
	id = 14360,
	name = "试作型三联装406mm主炮MkD",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 14360	};
	}
};
{
	id = 14380,
	name = "三联装406mm主炮Mk2",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 14380	};
	}
};
{
	id = 14400,
	name = "三联装406mm主炮Mk7",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 14460	};
		{	tech = 1, rarity = 3, id = 14400	};
		{	tech = 2, rarity = 4, id = 14420	};
		{	tech = 3, rarity = 5, id = 14440	};
	}
};
{
	id = 14480,
	name = "试作型三联装406mm/45主炮Mk7",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 14480	};
	}
};
{
	id = 14500,
	name = "试作型双联装457mm主炮Mk A",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 14500	};
	}
};
{
	id = 14520,
	name = "试作型双联装406mm主炮Mk4",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 14520	};
	}
};
{
	id = 14540,
	name = "试作型三联装406mm主炮Mk6改",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 14540	};
	}
};
{
	id = 15000,
	name = "潜艇用Mark 14鱼雷",
	type = 13,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 15000	};
		{	tech = 2, rarity = 3, id = 15020	};
		{	tech = 3, rarity = 4, id = 15040	};
	}
};
{
	id = 15060,
	name = "潜艇用Mark 18鱼雷",
	type = 13,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 15060	};
	}
};
{
	id = 15100,
	name = "潜艇用Mark 16鱼雷",
	type = 13,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 15100	};
		{	tech = 2, rarity = 4, id = 15120	};
		{	tech = 3, rarity = 5, id = 15140	};
	}
};
{
	id = 15160,
	name = "潜艇用Mark 28鱼雷",
	type = 13,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 15160	};
	}
};
{
	id = 15200,
	name = "三联装533mm鱼雷Mk17",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 15200	};
	}
};
{
	id = 15220,
	name = "四联装533mm鱼雷Mk17",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 15220	};
	}
};
{
	id = 15240,
	name = "五联装533mm鱼雷Mk17",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 15240	};
	}
};
{
	id = 15300,
	name = "533mm鱼雷Mark35（4连发射）",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 15300	};
	}
};
{
	id = 15500,
	name = "PBY-5A卡特琳娜水上机",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 15500	};
	}
};
{
	id = 16000,
	name = "20mm厄利孔高射炮",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 16000	};
		{	tech = 2, rarity = 2, id = 16020	};
		{	tech = 3, rarity = 3, id = 16040	};
	}
};
{
	id = 16060,
	name = "76mm高射炮改进型",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 16060	};
	}
};
{
	id = 16080,
	name = "双联装76mmRF火炮Mk27",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 16080	};
	}
};
{
	id = 16100,
	name = "双管20mm厄利孔高射炮",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 16100	};
		{	tech = 2, rarity = 3, id = 16120	};
		{	tech = 3, rarity = 4, id = 16140	};
	}
};
{
	id = 16160,
	name = "四联装20mm厄利孔高射炮Mk15",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 16160	};
	}
};
{
	id = 16200,
	name = "四联装28mm“芝加哥钢琴”",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 16200	};
		{	tech = 2, rarity = 3, id = 16220	};
		{	tech = 3, rarity = 4, id = 16240	};
	}
};
{
	id = 16300,
	name = "双联40mm博福斯对空机炮",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 16300	};
		{	tech = 2, rarity = 3, id = 16320	};
		{	tech = 3, rarity = 4, id = 16340	};
	}
};
{
	id = 16400,
	name = "四联40mm博福斯对空机炮",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 16400	};
		{	tech = 2, rarity = 4, id = 16420	};
		{	tech = 3, rarity = 5, id = 16440	};
	}
};
{
	id = 16460,
	name = "双联装127mm高平两用炮Mk12(定时引信)",
	type = 21,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 16460	};
	}
};
{
	id = 16480,
	name = "双联装76mmRF火炮Mk37",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 16480	};
	}
};
{
	id = 17000,
	name = "F2A水牛",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 17000	};
		{	tech = 2, rarity = 2, id = 17020	};
		{	tech = 3, rarity = 3, id = 17040	};
	}
};
{
	id = 17060,
	name = "F2A水牛(萨奇队)",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17060	};
	}
};
{
	id = 17080,
	name = "试作型XF2A-4水牛",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 17080	};
	}
};
{
	id = 17100,
	name = "F4F野猫",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 17100	};
		{	tech = 2, rarity = 3, id = 17120	};
		{	tech = 3, rarity = 4, id = 17140	};
	}
};
{
	id = 17200,
	name = "F4U海盗",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 17200	};
		{	tech = 2, rarity = 3, id = 17220	};
		{	tech = 3, rarity = 4, id = 17240	};
	}
};
{
	id = 17260,
	name = "F4U（VF-17“海盗”中队）",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17260	};
	}
};
{
	id = 17280,
	name = "F4U海盗（VBF-94中队）",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17280	};
	}
};
{
	id = 17300,
	name = "F6F地狱猫",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 17300	};
		{	tech = 2, rarity = 4, id = 17320	};
		{	tech = 3, rarity = 5, id = 17340	};
	}
};
{
	id = 17360,
	name = "F7F虎猫",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17360	};
	}
};
{
	id = 17380,
	name = "F8F熊猫",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17380	};
	}
};
{
	id = 17400,
	name = "XF5F天箭",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 17400	};
	}
};
{
	id = 17420,
	name = "试作型XF5U飞碟",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17420	};
	}
};
{
	id = 17440,
	name = "F6F地狱猫（HVAR搭载型）",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17440	};
	}
};
{
	id = 17460,
	name = "试作型F8F熊猫（浮筒型）",
	type = 12,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 17460	};
	}
};
{
	id = 18000,
	name = "TBD蹂躏者",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 18000	};
		{	tech = 2, rarity = 2, id = 18020	};
		{	tech = 3, rarity = 3, id = 18040	};
	}
};
{
	id = 18060,
	name = "TBD蹂躏者(VT-8中队)",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 18060	};
	}
};
{
	id = 18100,
	name = "TBF复仇者",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 18100	};
		{	tech = 2, rarity = 3, id = 18120	};
		{	tech = 3, rarity = 4, id = 18140	};
	}
};
{
	id = 18180,
	name = "TBM复仇者(VT-18中队)",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 18180	};
	}
};
{
	id = 18220,
	name = "XTB2D-1天空海盗",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 18220	};
	}
};
{
	id = 19000,
	name = "SBD无畏",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 19000	};
		{	tech = 2, rarity = 2, id = 19020	};
		{	tech = 3, rarity = 3, id = 19040	};
	}
};
{
	id = 19060,
	name = "SBD无畏(麦克拉斯基队)",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 19060	};
	}
};
{
	id = 19100,
	name = "SB2C地狱俯冲者",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 19100	};
		{	tech = 2, rarity = 3, id = 19120	};
		{	tech = 3, rarity = 4, id = 19140	};
	}
};
{
	id = 19160,
	name = "实验型XSB3C-1",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 19160	};
	}
};
{
	id = 19200,
	name = "BTD-1毁灭者",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 19200	};
		{	tech = 2, rarity = 4, id = 19220	};
		{	tech = 3, rarity = 5, id = 19240	};
	}
};
{
	id = 19300,
	name = "AD-1天袭者",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 19300	};
	}
};
{
	id = 21000,
	name = "单装102mm副炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 21000	};
		{	tech = 2, rarity = 2, id = 21020	};
		{	tech = 3, rarity = 3, id = 21040	};
	}
};
{
	id = 21100,
	name = "双联装102mm副炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 21100	};
		{	tech = 2, rarity = 2, id = 21120	};
		{	tech = 3, rarity = 3, id = 21140	};
	}
};
{
	id = 21160,
	name = "双联装102mm副炮Mark XVI",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 21160	};
	}
};
{
	id = 21200,
	name = "三联装102mm副炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 21200	};
		{	tech = 2, rarity = 3, id = 21220	};
		{	tech = 3, rarity = 4, id = 21240	};
	}
};
{
	id = 21300,
	name = "120mm单装炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 21300	};
		{	tech = 1, rarity = 1, id = 31100	};
		{	tech = 2, rarity = 2, id = 21320	};
		{	tech = 2, rarity = 2, id = 31120	};
		{	tech = 3, rarity = 3, id = 21340	};
		{	tech = 3, rarity = 3, id = 31140	};
	}
};
{
	id = 21400,
	name = "双联装120mm主炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 21400	};
		{	tech = 1, rarity = 2, id = 95560	};
		{	tech = 2, rarity = 3, id = 21420	};
		{	tech = 3, rarity = 4, id = 21440	};
		{	tech = 3, rarity = 4, id = 95580	};
	}
};
{
	id = 21460,
	name = "双联装120mm高平两用炮Mark XI",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 21460	};
	}
};
{
	id = 21500,
	name = "双联装134mm高炮",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 26640	};
		{	tech = 1, rarity = 2, id = 21500	};
		{	tech = 2, rarity = 3, id = 21520	};
		{	tech = 3, rarity = 4, id = 21540	};
	}
};
{
	id = 21600,
	name = "双联装114mm高平两用炮Mark IV",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 21600	};
	}
};
{
	id = 21620,
	name = "单装113mm高平两用炮Mark IV",
	type = 1,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 21620	};
	}
};
{
	id = 22000,
	name = "单装152mm副炮",
	type = 2,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 22000	};
		{	tech = 2, rarity = 2, id = 22020	};
		{	tech = 3, rarity = 3, id = 22040	};
	}
};
{
	id = 22060,
	name = "双联装152mm副炮",
	type = 2,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 22060	};
	}
};
{
	id = 22100,
	name = "双联装152mm主炮",
	type = 2,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 22100	};
		{	tech = 2, rarity = 3, id = 22120	};
		{	tech = 3, rarity = 4, id = 22140	};
	}
};
{
	id = 22260,
	name = "试作型三联装152mm主炮",
	type = 2,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 22260	};
	}
};
{
	id = 22280,
	name = "试作型四联装152mm主炮",
	type = 2,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 22280	};
	}
};
{
	id = 23000,
	name = "双联装203mm主炮",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 23000	};
		{	tech = 2, rarity = 3, id = 23020	};
		{	tech = 3, rarity = 4, id = 23040	};
	}
};
{
	id = 23100,
	name = "试作型双联装234mm主炮",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 23100	};
	}
};
{
	id = 23120,
	name = "试作型三联装234mm主炮",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 23120	};
	}
};
{
	id = 23200,
	name = "试作型三联装203mm主炮Mark IX",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 23200	};
	}
};
{
	id = 23220,
	name = "试作型三联装203mm主炮Mark X",
	type = 3,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 23220	};
	}
};
{
	id = 24000,
	name = "四联装356mm主炮",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 24000	};
		{	tech = 2, rarity = 4, id = 24020	};
		{	tech = 3, rarity = 5, id = 24040	};
	}
};
{
	id = 24060,
	name = "双联装356mm主炮",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 24060	};
	}
};
{
	id = 24100,
	name = "双联装381mm主炮",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 24100	};
		{	tech = 2, rarity = 3, id = 24120	};
		{	tech = 3, rarity = 4, id = 24140	};
	}
};
{
	id = 24160,
	name = "试作型三联装381mm主炮",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 24160	};
	}
};
{
	id = 24200,
	name = "三联装406mm主炮",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 24200	};
		{	tech = 2, rarity = 4, id = 24220	};
		{	tech = 3, rarity = 5, id = 24240	};
	}
};
{
	id = 24300,
	name = "双联装381mm主炮改",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 24340	};
		{	tech = 1, rarity = 3, id = 24300	};
		{	tech = 2, rarity = 4, id = 24320	};
	}
};
{
	id = 24400,
	name = "试作型三联装406mm主炮Mk.II",
	type = 4,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 24400	};
	}
};
{
	id = 25000,
	name = "三联装533mm鱼雷Mark IX",
	type = 5,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 25000	};
	}
};
{
	id = 25020,
	name = "四联装533mm鱼雷Mark IX",
	type = 5,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 25020	};
	}
};
{
	id = 25040,
	name = "五联装533mm鱼雷Mark IX",
	type = 5,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 25040	};
	}
};
{
	id = 25100,
	name = "潜艇用Mark VIII鱼雷",
	type = 13,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 25100	};
		{	tech = 2, rarity = 3, id = 25120	};
		{	tech = 3, rarity = 4, id = 25140	};
	}
};
{
	id = 25200,
	name = "潜艇用Mark 12鱼雷-菲里",
	type = 13,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 25200	};
	}
};
{
	id = 25300,
	name = "潜艇用Mark 20 S鱼雷-彼得",
	type = 13,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 25300	};
	}
};
{
	id = 25800,
	name = "刺猬弹",
	type = 14,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 25800	};
	}
};
{
	id = 26000,
	name = "双联装40mm“砰砰”炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 26000	};
		{	tech = 2, rarity = 2, id = 26020	};
		{	tech = 3, rarity = 3, id = 26040	};
	}
};
{
	id = 26060,
	name = "双联装40mm博福斯对空机炮Mark I",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 26060	};
	}
};
{
	id = 26100,
	name = "四联装40mm“砰砰”炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 26100	};
		{	tech = 2, rarity = 3, id = 26120	};
		{	tech = 3, rarity = 4, id = 26140	};
	}
};
{
	id = 26200,
	name = "八联装40mm“砰砰”炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 26200	};
		{	tech = 2, rarity = 4, id = 26220	};
		{	tech = 3, rarity = 5, id = 26240	};
	}
};
{
	id = 26300,
	name = "76mm高射炮",
	type = 6,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 26300	};
		{	tech = 1, rarity = 2, id = 36500	};
		{	tech = 2, rarity = 3, id = 26320	};
		{	tech = 2, rarity = 3, id = 36520	};
		{	tech = 3, rarity = 4, id = 26340	};
		{	tech = 3, rarity = 4, id = 36540	};
	}
};
{
	id = 26360,
	name = "20mm厄利孔高射炮MkII",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 26360	};
	}
};
{
	id = 26380,
	name = "双管20mm厄利孔高射炮Mk.V ",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 26380	};
	}
};
{
	id = 26400,
	name = "102mm高射炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 26400	};
		{	tech = 2, rarity = 3, id = 26420	};
		{	tech = 3, rarity = 4, id = 26440	};
	}
};
{
	id = 26460,
	name = "120mm高射炮Mark VIII",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 26460	};
	}
};
{
	id = 26500,
	name = "双联装113mm高射炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 26500	};
		{	tech = 2, rarity = 4, id = 26520	};
		{	tech = 3, rarity = 5, id = 26540	};
	}
};
{
	id = 26600,
	name = "双联装40mm博福斯STAAG",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 26600	};
	}
};
{
	id = 26620,
	name = "双联装40mm博福斯海兹梅耶",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 26620	};
	}
};
{
	id = 26660,
	name = "六联装40mm博福斯对空机炮",
	type = 6,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 26660	};
	}
};
{
	id = 26680,
	name = "双联装134mm高炮(定时引信)",
	type = 21,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 26680	};
	}
};
{
	id = 27000,
	name = "海喷火",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 27000	};
		{	tech = 2, rarity = 3, id = 27020	};
		{	tech = 3, rarity = 4, id = 27040	};
	}
};
{
	id = 27060,
	name = "海喷火FR.47",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 27060	};
	}
};
{
	id = 27100,
	name = "海毒牙",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 27100	};
		{	tech = 2, rarity = 4, id = 27120	};
		{	tech = 3, rarity = 5, id = 27140	};
	}
};
{
	id = 27200,
	name = "海斗士",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 27200	};
		{	tech = 2, rarity = 2, id = 27220	};
		{	tech = 3, rarity = 3, id = 27240	};
	}
};
{
	id = 27260,
	name = "海飓风",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 27260	};
	}
};
{
	id = 27300,
	name = "海怒",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 27300	};
	}
};
{
	id = 27320,
	name = "海大黄蜂",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 27320	};
	}
};
{
	id = 28000,
	name = "剑鱼",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 28000	};
		{	tech = 2, rarity = 3, id = 28020	};
		{	tech = 3, rarity = 4, id = 28040	};
	}
};
{
	id = 28060,
	name = "剑鱼(818中队)",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 28060	};
	}
};
{
	id = 28100,
	name = "梭鱼",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 28100	};
		{	tech = 2, rarity = 4, id = 28120	};
		{	tech = 3, rarity = 5, id = 28140	};
	}
};
{
	id = 28200,
	name = "火把",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 28200	};
	}
};
{
	id = 28220,
	name = "火冠",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 28220	};
	}
};
{
	id = 28300,
	name = "青花鱼",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 28300	};
		{	tech = 2, rarity = 3, id = 28320	};
		{	tech = 3, rarity = 4, id = 28340	};
	}
};
{
	id = 28400,
	name = "飞龙",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 28400	};
	}
};
{
	id = 28420,
	name = "试作型旗鱼",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 28420	};
	}
};
{
	id = 29000,
	name = "贼鸥",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 29000	};
		{	tech = 2, rarity = 2, id = 29020	};
		{	tech = 3, rarity = 3, id = 29040	};
	}
};
{
	id = 29100,
	name = "海燕",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 29100	};
		{	tech = 2, rarity = 3, id = 29120	};
		{	tech = 3, rarity = 4, id = 29140	};
	}
};
{
	id = 29200,
	name = "萤火虫",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 29200	};
	}
};
{
	id = 29220,
	name = "萤火虫(1771中队)",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 29220	};
	}
};
{
	id = 29300,
	name = "梭鱼(831中队)",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 29300	};
	}
};
{
	id = 30000,
	name = "305mm连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 30000	};
	}
};
{
	id = 31000,
	name = "双联100mm98式高射炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 31000	};
		{	tech = 2, rarity = 4, id = 31020	};
		{	tech = 3, rarity = 5, id = 31040	};
	}
};
{
	id = 31060,
	name = "100mm88式火炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 31060	};
	}
};
{
	id = 31080,
	name = "双联100mm98式高射炮改",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 31080	};
	}
};
{
	id = 31160,
	name = "十一年式120mm单装炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 31160	};
	}
};
{
	id = 31180,
	name = "120mm单装高角炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 31180	};
	}
};
{
	id = 31200,
	name = "127mm连装炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 31200	};
		{	tech = 2, rarity = 3, id = 31220	};
		{	tech = 3, rarity = 4, id = 31240	};
	}
};
{
	id = 31260,
	name = "127mm单装两用炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 31260	};
	}
};
{
	id = 31280,
	name = "127mm连装炮改",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 31280	};
	}
};
{
	id = 31300,
	name = "127mm连装炮（D型）",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 31300	};
	}
};
{
	id = 32000,
	name = "140mm单装炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 32000	};
		{	tech = 2, rarity = 2, id = 32020	};
		{	tech = 3, rarity = 3, id = 32040	};
	}
};
{
	id = 32060,
	name = "152mm单装炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 32060	};
	}
};
{
	id = 32100,
	name = "140mm连装炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 32100	};
		{	tech = 2, rarity = 3, id = 32120	};
		{	tech = 3, rarity = 4, id = 32140	};
	}
};
{
	id = 32200,
	name = "155mm三连装炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 32200	};
		{	tech = 2, rarity = 4, id = 32220	};
		{	tech = 3, rarity = 5, id = 32240	};
	}
};
{
	id = 32260,
	name = "试作型155mm三连装炮改",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 32260	};
	}
};
{
	id = 32300,
	name = "152mm连装炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 32300	};
		{	tech = 2, rarity = 3, id = 32320	};
		{	tech = 3, rarity = 4, id = 32340	};
	}
};
{
	id = 32360,
	name = "试作型三联装150mm五式高平两用炮",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 32360	};
	}
};
{
	id = 33000,
	name = "203mm连装炮",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 33000	};
		{	tech = 2, rarity = 3, id = 33020	};
		{	tech = 3, rarity = 4, id = 33040	};
	}
};
{
	id = 33060,
	name = "试作型203mm(3号)连装炮",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 33060	};
	}
};
{
	id = 33080,
	name = "203mm连装炮改",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 33080	};
	}
};
{
	id = 33100,
	name = "试作型三联装310mm主炮",
	type = 11,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 33100	};
	}
};
{
	id = 33120,
	name = "试作型203mm/55三连装主炮",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 33120	};
	}
};
{
	id = 34000,
	name = "356mm连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 34000	};
		{	tech = 2, rarity = 2, id = 34020	};
		{	tech = 3, rarity = 3, id = 34040	};
	}
};
{
	id = 34060,
	name = "356mm毘式连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 34060	};
	}
};
{
	id = 34100,
	name = "410mm连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 34100	};
		{	tech = 2, rarity = 3, id = 34120	};
		{	tech = 3, rarity = 4, id = 34140	};
	}
};
{
	id = 34160,
	name = "410mm连装炮(三式弹)",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 34160	};
	}
};
{
	id = 34180,
	name = "试作型410mm三连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 34180	};
	}
};
{
	id = 34200,
	name = "460mm三连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 34240	};
		{	tech = 1, rarity = 4, id = 34200	};
		{	tech = 2, rarity = 5, id = 34220	};
	}
};
{
	id = 34300,
	name = "410mm连装炮改",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 34300	};
	}
};
{
	id = 34320,
	name = "试作型双联装410mm主炮Mod.A",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 34320	};
	}
};
{
	id = 35000,
	name = "双联装610mm鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 35000	};
		{	tech = 2, rarity = 2, id = 35020	};
		{	tech = 3, rarity = 3, id = 35040	};
	}
};
{
	id = 35100,
	name = "三联装610mm鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 35100	};
		{	tech = 2, rarity = 3, id = 35120	};
		{	tech = 3, rarity = 4, id = 35140	};
	}
};
{
	id = 35160,
	name = "三联装610mm鱼雷改",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 35160	};
	}
};
{
	id = 35200,
	name = "四联装610mm鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 35200	};
		{	tech = 2, rarity = 4, id = 35220	};
		{	tech = 3, rarity = 5, id = 35240	};
	}
};
{
	id = 35260,
	name = "四联装610mm鱼雷改",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 35260	};
	}
};
{
	id = 35300,
	name = "五联装610mm鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 35340	};
		{	tech = 1, rarity = 4, id = 35300	};
		{	tech = 2, rarity = 5, id = 35320	};
	}
};
{
	id = 35400,
	name = "潜艇用92式潜射鱼雷",
	type = 13,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 35400	};
		{	tech = 2, rarity = 3, id = 35420	};
		{	tech = 3, rarity = 4, id = 35440	};
	}
};
{
	id = 35460,
	name = "潜艇用92式潜射鱼雷改",
	type = 13,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 35460	};
	}
};
{
	id = 35500,
	name = "潜艇用95式纯氧鱼雷",
	type = 13,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 35500	};
		{	tech = 2, rarity = 4, id = 35520	};
		{	tech = 3, rarity = 5, id = 35540	};
	}
};
{
	id = 35560,
	name = "潜艇用96式纯氧鱼雷",
	type = 13,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 35560	};
	}
};
{
	id = 35580,
	name = "潜艇用95式纯氧鱼雷改",
	type = 13,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 35580	};
	}
};
{
	id = 36100,
	name = "25mm高射机枪",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 36100	};
		{	tech = 2, rarity = 2, id = 36120	};
		{	tech = 3, rarity = 3, id = 36140	};
	}
};
{
	id = 36200,
	name = "25mm连装高射机枪",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 36200	};
		{	tech = 2, rarity = 3, id = 36220	};
		{	tech = 3, rarity = 4, id = 36240	};
	}
};
{
	id = 36300,
	name = "25mm三连装高射机枪",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 36300	};
		{	tech = 2, rarity = 3, id = 36320	};
		{	tech = 3, rarity = 4, id = 36340	};
	}
};
{
	id = 36360,
	name = "九六式25mm三连装暴风避盾机炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36360	};
	}
};
{
	id = 36400,
	name = "毘式40mm连装机枪",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 36400	};
		{	tech = 2, rarity = 3, id = 36420	};
		{	tech = 3, rarity = 4, id = 36440	};
	}
};
{
	id = 36560,
	name = "100mm连装高炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36560	};
	}
};
{
	id = 36580,
	name = "80mm高射炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 36580	};
	}
};
{
	id = 36600,
	name = "127mm连装高射炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 36600	};
		{	tech = 2, rarity = 3, id = 36620	};
		{	tech = 3, rarity = 4, id = 36640	};
	}
};
{
	id = 36660,
	name = "127mm连装高角炮改",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36660	};
	}
};
{
	id = 36700,
	name = "试作型五式40mm高射机关炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36700	};
	}
};
{
	id = 36720,
	name = "127mm连装高角炮改(定时引信)",
	type = 21,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36720	};
	}
};
{
	id = 36740,
	name = "80mm98式连装高炮",
	type = 6,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 36740	};
	}
};
{
	id = 37000,
	name = "九六式舰战",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 37000	};
		{	tech = 2, rarity = 2, id = 37020	};
		{	tech = 3, rarity = 3, id = 37040	};
	}
};
{
	id = 37100,
	name = "零战二一型",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 37100	};
		{	tech = 2, rarity = 3, id = 37120	};
		{	tech = 3, rarity = 4, id = 37140	};
	}
};
{
	id = 37160,
	name = "零战三二型",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 37160	};
	}
};
{
	id = 37200,
	name = "零战五二型",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 37200	};
		{	tech = 2, rarity = 4, id = 37220	};
		{	tech = 3, rarity = 5, id = 37240	};
	}
};
{
	id = 37300,
	name = "烈风",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 37300	};
		{	tech = 2, rarity = 4, id = 37320	};
		{	tech = 3, rarity = 5, id = 37340	};
	}
};
{
	id = 37400,
	name = "紫电改二",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 37400	};
	}
};
{
	id = 37420,
	name = "二式水上战斗机",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 37420	};
	}
};
{
	id = 37440,
	name = "强风",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 37440	};
	}
};
{
	id = 37460,
	name = "试作型紫电改四",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 37460	};
	}
};
{
	id = 38000,
	name = "九七式舰攻",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 38000	};
		{	tech = 2, rarity = 2, id = 38020	};
		{	tech = 3, rarity = 3, id = 38040	};
	}
};
{
	id = 38060,
	name = "九七式舰攻改",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 38060	};
	}
};
{
	id = 38100,
	name = "天山",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 38100	};
		{	tech = 2, rarity = 3, id = 38120	};
		{	tech = 3, rarity = 4, id = 38140	};
	}
};
{
	id = 38160,
	name = "天山改",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 38160	};
	}
};
{
	id = 38200,
	name = "流星",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 38200	};
		{	tech = 2, rarity = 4, id = 38220	};
		{	tech = 3, rarity = 5, id = 38240	};
	}
};
{
	id = 38260,
	name = "流星改",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 38260	};
	}
};
{
	id = 38300,
	name = "试作型彩云（舰攻型）",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 38300	};
	}
};
{
	id = 39000,
	name = "九九式舰爆",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 39000	};
		{	tech = 2, rarity = 3, id = 39020	};
		{	tech = 3, rarity = 4, id = 39040	};
	}
};
{
	id = 39060,
	name = "九九式舰爆改",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 39060	};
	}
};
{
	id = 39100,
	name = "彗星",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 39100	};
		{	tech = 2, rarity = 4, id = 39120	};
		{	tech = 3, rarity = 5, id = 39140	};
	}
};
{
	id = 39160,
	name = "彗星一二型甲",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 39160	};
	}
};
{
	id = 39200,
	name = "瑞云",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 39200	};
		{	tech = 2, rarity = 3, id = 39220	};
		{	tech = 3, rarity = 4, id = 39240	};
	}
};
{
	id = 39300,
	name = "晴岚",
	type = 12,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 39300	};
	}
};
{
	id = 39320,
	name = "彗星二一型",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 39320	};
	}
};
{
	id = 39340,
	name = "试作舰载型天雷",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 39340	};
	}
};
{
	id = 41000,
	name = "单装127mm主炮",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 41000	};
		{	tech = 2, rarity = 2, id = 41020	};
		{	tech = 3, rarity = 3, id = 41040	};
	}
};
{
	id = 41060,
	name = "双联装127mmKM40主炮",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 41060	};
	}
};
{
	id = 41100,
	name = "双联装128mmSKC41高平两用炮",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 41100	};
		{	tech = 2, rarity = 3, id = 41120	};
		{	tech = 3, rarity = 4, id = 41140	};
	}
};
{
	id = 41160,
	name = "双联装128mmSKC41高平两用炮改",
	type = 1,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 41160	};
	}
};
{
	id = 42000,
	name = "单装SKC28式150mm主炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 42000	};
		{	tech = 2, rarity = 3, id = 42020	};
		{	tech = 3, rarity = 4, id = 42040	};
	}
};
{
	id = 42060,
	name = "双联装SKC28式150mm副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 42060	};
	}
};
{
	id = 42080,
	name = "试作型双联装SKC28式150mm主炮改",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 42080	};
	}
};
{
	id = 42100,
	name = "三联装SKC25式150mm主炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 42100	};
		{	tech = 2, rarity = 3, id = 42120	};
		{	tech = 3, rarity = 4, id = 42140	};
	}
};
{
	id = 42160,
	name = "三联装SKC25式150mm主炮改",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 42160	};
	}
};
{
	id = 42200,
	name = "双联装TbtsKC36式150mm主炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 42200	};
		{	tech = 2, rarity = 3, id = 42220	};
		{	tech = 3, rarity = 4, id = 42240	};
	}
};
{
	id = 42300,
	name = "单装TbtsKC36式150mm主炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 42300	};
		{	tech = 3, rarity = 4, id = 42340	};
	}
};
{
	id = 42360,
	name = "试作型双联装TbtsKC42T式150mm主炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 42360	};
	}
};
{
	id = 43000,
	name = "双联装203mmSKC主炮",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 43000	};
		{	tech = 2, rarity = 4, id = 43020	};
		{	tech = 3, rarity = 5, id = 43040	};
	}
};
{
	id = 43060,
	name = "试作型三联装203mmSKC主炮",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 43060	};
	}
};
{
	id = 43080,
	name = "双联装203mmSKC主炮改",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 43080	};
	}
};
{
	id = 43100,
	name = "三联283mmSKC28主炮",
	type = 11,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 43100	};
		{	tech = 2, rarity = 3, id = 43120	};
		{	tech = 3, rarity = 4, id = 43140	};
	}
};
{
	id = 43160,
	name = "试作型三联装203mmSKC主炮改",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 43160	};
	}
};
{
	id = 44000,
	name = "三联283mmSKC34主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 44000	};
		{	tech = 2, rarity = 3, id = 44020	};
		{	tech = 3, rarity = 4, id = 44040	};
	}
};
{
	id = 44100,
	name = "双联380mmSKC主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 44100	};
		{	tech = 2, rarity = 4, id = 44120	};
		{	tech = 3, rarity = 5, id = 44140	};
	}
};
{
	id = 44200,
	name = "试作型双联装406mmSKC主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 44200	};
	}
};
{
	id = 44300,
	name = "试作型三联装305mmSKC39主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 44300	};
	}
};
{
	id = 44320,
	name = "试作型四联装305mmSKC39主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 44320	};
	}
};
{
	id = 44400,
	name = "试作型三联装305mmSKC39主炮（超巡用）",
	type = 11,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 44400	};
	}
};
{
	id = 44420,
	name = "试作型三联装283mm/54.5主炮",
	type = 11,
	nationality = 11,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 44420	};
	}
};
{
	id = 44500,
	name = "试作型三联装380mmSKC主炮",
	type = 4,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 44500	};
	}
};
{
	id = 45000,
	name = "三联装533mm磁性鱼雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 45000	};
		{	tech = 2, rarity = 3, id = 45020	};
		{	tech = 3, rarity = 4, id = 45040	};
	}
};
{
	id = 45100,
	name = "四联装533mm磁性鱼雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 45100	};
		{	tech = 2, rarity = 4, id = 45120	};
		{	tech = 3, rarity = 5, id = 45140	};
	}
};
{
	id = 45160,
	name = "四联装533mm磁性鱼雷改",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 45160	};
	}
};
{
	id = 45200,
	name = "五联装533mm磁性鱼雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 4, id = 45200	};
		{	tech = 2, rarity = 5, id = 45220	};
		{	tech = 3, rarity = 6, id = 45240	};
	}
};
{
	id = 45300,
	name = "潜艇用G7a鱼雷",
	type = 13,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 45300	};
		{	tech = 2, rarity = 3, id = 45320	};
		{	tech = 3, rarity = 4, id = 45340	};
	}
};
{
	id = 45400,
	name = "潜艇用G7e声导鱼雷",
	type = 13,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 45400	};
		{	tech = 2, rarity = 4, id = 45420	};
		{	tech = 3, rarity = 5, id = 45440	};
	}
};
{
	id = 45460,
	name = "潜艇用G7e声导鱼雷改",
	type = 13,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 45460	};
	}
};
{
	id = 46000,
	name = "四联装20mm MG机枪",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 46000	};
		{	tech = 2, rarity = 2, id = 46020	};
		{	tech = 3, rarity = 3, id = 46040	};
	}
};
{
	id = 46060,
	name = "双联装88mmSKC32高炮",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 46060	};
	}
};
{
	id = 46100,
	name = "37mm机枪",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 46100	};
		{	tech = 2, rarity = 2, id = 46120	};
		{	tech = 3, rarity = 3, id = 46140	};
	}
};
{
	id = 46200,
	name = "双联37mm手拉机枪",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 46200	};
		{	tech = 2, rarity = 3, id = 46220	};
		{	tech = 3, rarity = 4, id = 46240	};
	}
};
{
	id = 46260,
	name = "双联37mm Flak M43机枪",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 46260	};
	}
};
{
	id = 46300,
	name = "双联105mmSKC高炮",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 46300	};
		{	tech = 2, rarity = 4, id = 46320	};
		{	tech = 3, rarity = 5, id = 46340	};
	}
};
{
	id = 46360,
	name = "双联105mmSKC高炮改进型",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 46360	};
	}
};
{
	id = 46380,
	name = "双联105mmSKC高炮改进型(定时引信)",
	type = 21,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 46380	};
	}
};
{
	id = 46400,
	name = "试作型四联装30mm机炮",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 46400	};
	}
};
{
	id = 46420,
	name = "试作型55mm Gerät 58防空炮",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 46420	};
	}
};
{
	id = 46440,
	name = "单装40mm Flak28机炮",
	type = 6,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 46440	};
	}
};
{
	id = 47000,
	name = "BF-109T舰载战斗机",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 47000	};
		{	tech = 2, rarity = 3, id = 47020	};
		{	tech = 3, rarity = 4, id = 47040	};
	}
};
{
	id = 47060,
	name = "Ar-197舰载战斗机",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 47060	};
	}
};
{
	id = 47080,
	name = "试作型舰载FW-190 A-5",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 47080	};
	}
};
{
	id = 47100,
	name = "Me-155A舰载战斗机",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 47100	};
		{	tech = 2, rarity = 4, id = 47120	};
		{	tech = 3, rarity = 5, id = 47140	};
	}
};
{
	id = 47160,
	name = "试作舰载型BF-109G",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 47160	};
	}
};
{
	id = 47180,
	name = "试作舰载型FW-190 A-6/R6",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 47180	};
	}
};
{
	id = 47200,
	name = "试作舰载型FW-190 G-3/R1",
	type = 7,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 47200	};
	}
};
{
	id = 48000,
	name = "Ar-195舰载鱼雷机",
	type = 8,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 48000	};
	}
};
{
	id = 48020,
	name = "Fi-167舰载鱼雷机",
	type = 8,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 48020	};
	}
};
{
	id = 48040,
	name = "Ju-87 D-4",
	type = 8,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 48040	};
	}
};
{
	id = 49000,
	name = "Ju-87C俯冲轰炸机",
	type = 9,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 49000	};
		{	tech = 2, rarity = 3, id = 49020	};
		{	tech = 3, rarity = 4, id = 49040	};
	}
};
{
	id = 49060,
	name = "He-50b舰载轰炸机",
	type = 9,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 49060	};
	}
};
{
	id = 54010,
	name = "轻航专用空中支援技能-轰炸Lv1",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 54010	};
	}
};
{
	id = 54011,
	name = "轻航专用空中支援技能-轰炸Lv2",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 54011	};
	}
};
{
	id = 54012,
	name = "轻航专用空中支援技能-轰炸Lv3",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 54012	};
	}
};
{
	id = 54013,
	name = "正航专用空中支援技能-轰炸Lv1",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 54013	};
	}
};
{
	id = 54014,
	name = "正航专用空中支援技能-轰炸Lv2",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 54014	};
	}
};
{
	id = 54015,
	name = "正航专用空中支援技能-轰炸Lv3",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 54015	};
	}
};
{
	id = 60001,
	name = "航空攻击展示-长岛I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60001	};
	}
};
{
	id = 60002,
	name = "航空攻击展示-长岛II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60002	};
	}
};
{
	id = 60003,
	name = "航空攻击展示-长岛III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60003	};
	}
};
{
	id = 60011,
	name = "航空攻击展示-博格I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60011	};
	}
};
{
	id = 60012,
	name = "航空攻击展示-博格II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60012	};
	}
};
{
	id = 60013,
	name = "航空攻击展示-博格III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60013	};
	}
};
{
	id = 60021,
	name = "航空攻击展示-兰利I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60021	};
	}
};
{
	id = 60022,
	name = "航空攻击展示-兰利II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60022	};
	}
};
{
	id = 60023,
	name = "航空攻击展示-兰利III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60023	};
	}
};
{
	id = 60031,
	name = "航空攻击展示-列克星敦I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60031	};
	}
};
{
	id = 60032,
	name = "航空攻击展示-列克星敦II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60032	};
	}
};
{
	id = 60033,
	name = "航空攻击展示-列克星敦III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60033	};
	}
};
{
	id = 60041,
	name = "航空攻击展示-萨拉托加I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60041	};
	}
};
{
	id = 60042,
	name = "航空攻击展示-萨拉托加II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60042	};
	}
};
{
	id = 60043,
	name = "航空攻击展示-萨拉托加III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60043	};
	}
};
{
	id = 60051,
	name = "航空攻击展示-突击者I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60051	};
	}
};
{
	id = 60052,
	name = "航空攻击展示-突击者II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60052	};
	}
};
{
	id = 60053,
	name = "航空攻击展示-突击者III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60053	};
	}
};
{
	id = 60061,
	name = "航空攻击展示-约克城I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60061	};
	}
};
{
	id = 60062,
	name = "航空攻击展示-约克城II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60062	};
	}
};
{
	id = 60063,
	name = "航空攻击展示-约克城III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60063	};
	}
};
{
	id = 60071,
	name = "航空攻击展示-企业I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60071	};
	}
};
{
	id = 60072,
	name = "航空攻击展示-企业II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60072	};
	}
};
{
	id = 60073,
	name = "航空攻击展示-企业III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60073	};
	}
};
{
	id = 60081,
	name = "航空攻击展示-大黄蜂I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60081	};
	}
};
{
	id = 60082,
	name = "航空攻击展示-大黄蜂II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60082	};
	}
};
{
	id = 60083,
	name = "航空攻击展示-大黄蜂III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60083	};
	}
};
{
	id = 60091,
	name = "航空攻击展示-竞技神I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60091	};
	}
};
{
	id = 60092,
	name = "航空攻击展示-竞技神II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60092	};
	}
};
{
	id = 60101,
	name = "航空攻击展示-皇家方舟I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60101	};
	}
};
{
	id = 60102,
	name = "航空攻击展示-皇家方舟II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60102	};
	}
};
{
	id = 60103,
	name = "航空攻击展示-皇家方舟III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60103	};
	}
};
{
	id = 60111,
	name = "航空攻击展示-光辉I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60111	};
	}
};
{
	id = 60112,
	name = "航空攻击展示-光辉II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60112	};
	}
};
{
	id = 60113,
	name = "航空攻击展示-光辉III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60113	};
	}
};
{
	id = 60121,
	name = "航空攻击展示-祥凤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60121	};
	}
};
{
	id = 60122,
	name = "航空攻击展示-祥凤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60122	};
	}
};
{
	id = 60123,
	name = "航空攻击展示-祥凤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60123	};
	}
};
{
	id = 60131,
	name = "航空攻击展示-赤城I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60131	};
	}
};
{
	id = 60132,
	name = "航空攻击展示-赤城II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60132	};
		{	tech = 0, rarity = 0, id = 60133	};
	}
};
{
	id = 60141,
	name = "航空攻击展示-加贺I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60141	};
	}
};
{
	id = 60142,
	name = "航空攻击展示-加贺II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60142	};
		{	tech = 0, rarity = 0, id = 60143	};
	}
};
{
	id = 60151,
	name = "航空攻击展示-苍龙I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60151	};
	}
};
{
	id = 60152,
	name = "航空攻击展示-苍龙II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60152	};
		{	tech = 0, rarity = 0, id = 60153	};
	}
};
{
	id = 60161,
	name = "航空攻击展示-飞龙I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60161	};
	}
};
{
	id = 60162,
	name = "航空攻击展示-飞龙II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60162	};
		{	tech = 0, rarity = 0, id = 60163	};
	}
};
{
	id = 60171,
	name = "航空攻击展示-独角兽I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60171	};
	}
};
{
	id = 60172,
	name = "航空攻击展示-独角兽II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60172	};
	}
};
{
	id = 60173,
	name = "航空攻击展示-独角兽III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60173	};
	}
};
{
	id = 60181,
	name = "航空攻击展示-凤翔I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60181	};
	}
};
{
	id = 60182,
	name = "航空攻击展示-凤翔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60182	};
	}
};
{
	id = 60183,
	name = "航空攻击展示-凤翔III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60183	};
	}
};
{
	id = 60191,
	name = "航空攻击展示-齐柏林伯爵I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60191	};
	}
};
{
	id = 60192,
	name = "航空攻击展示-齐柏林伯爵II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60192	};
		{	tech = 0, rarity = 0, id = 60193	};
	}
};
{
	id = 60201,
	name = "航空攻击展示-翔鹤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60201	};
	}
};
{
	id = 60202,
	name = "航空攻击展示-翔鹤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60202	};
	}
};
{
	id = 60203,
	name = "航空攻击展示-翔鹤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60203	};
	}
};
{
	id = 60211,
	name = "航空攻击展示-瑞鹤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60211	};
	}
};
{
	id = 60212,
	name = "航空攻击展示-瑞鹤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60212	};
	}
};
{
	id = 60213,
	name = "航空攻击展示-瑞鹤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60213	};
	}
};
{
	id = 60221,
	name = "航空攻击展示-光荣I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60221	};
	}
};
{
	id = 60222,
	name = "航空攻击展示-光荣II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60222	};
	}
};
{
	id = 60223,
	name = "航空攻击展示-光荣III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60223	};
	}
};
{
	id = 60231,
	name = "烈焰崩袭",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60231	};
	}
};
{
	id = 60232,
	name = "蕾丝狂舞",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60232	};
	}
};
{
	id = 60233,
	name = "众神之怒·雪崩雷震",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60233	};
	}
};
{
	id = 60234,
	name = "雪风弹幕展示I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60234	};
	}
};
{
	id = 60235,
	name = "雪风弹幕展示II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60235	};
	}
};
{
	id = 60236,
	name = "夕立弹幕展示I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60236	};
	}
};
{
	id = 60237,
	name = "夕立弹幕展示II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60237	};
	}
};
{
	id = 60238,
	name = "江风弹幕展示I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60238	};
	}
};
{
	id = 60239,
	name = "江风弹幕展示II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60239	};
	}
};
{
	id = 60241,
	name = "航空攻击展示-贝露I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60241	};
	}
};
{
	id = 60242,
	name = "航空攻击展示-贝露II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60242	};
	}
};
{
	id = 60243,
	name = "航空攻击展示-贝露III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60243	};
	}
};
{
	id = 60251,
	name = "航空攻击展示-翡绿之心I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60251	};
	}
};
{
	id = 60252,
	name = "航空攻击展示-翡绿之心II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60252	};
	}
};
{
	id = 60253,
	name = "航空攻击展示-翡绿之心III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60253	};
	}
};
{
	id = 60261,
	name = "航空攻击展示-胡蜂I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60261	};
	}
};
{
	id = 60262,
	name = "航空攻击展示-胡蜂II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60262	};
	}
};
{
	id = 60263,
	name = "航空攻击展示-胡蜂III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60263	};
	}
};
{
	id = 60271,
	name = "航空攻击展示-胜利I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60271	};
	}
};
{
	id = 60272,
	name = "航空攻击展示-胜利II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60272	};
	}
};
{
	id = 60273,
	name = "航空攻击展示-胜利III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60273	};
	}
};
{
	id = 60281,
	name = "航空攻击展示-飞鹰I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60281	};
	}
};
{
	id = 60282,
	name = "航空攻击展示-飞鹰II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60282	};
	}
};
{
	id = 60283,
	name = "航空攻击展示-飞鹰III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60283	};
	}
};
{
	id = 60291,
	name = "航空攻击展示-隼鹰I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60291	};
	}
};
{
	id = 60292,
	name = "航空攻击展示-隼鹰II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60292	};
	}
};
{
	id = 60293,
	name = "航空攻击展示-隼鹰III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60293	};
	}
};
{
	id = 60301,
	name = "Z46弹幕展示I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60301	};
	}
};
{
	id = 60302,
	name = "Z46弹幕展示II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60302	};
	}
};
{
	id = 60311,
	name = "航空攻击展示-半人马I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60311	};
	}
};
{
	id = 60312,
	name = "航空攻击展示-半人马II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60312	};
	}
};
{
	id = 60313,
	name = "航空攻击展示-半人马III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60313	};
	}
};
{
	id = 60321,
	name = "航空攻击展示-埃塞克斯I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60321	};
	}
};
{
	id = 60322,
	name = "航空攻击展示-埃塞克斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60322	};
		{	tech = 0, rarity = 0, id = 60323	};
	}
};
{
	id = 60331,
	name = "航空攻击展示-大凤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60331	};
	}
};
{
	id = 60332,
	name = "航空攻击展示-大凤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60332	};
	}
};
{
	id = 60333,
	name = "航空攻击展示-大凤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60333	};
	}
};
{
	id = 60341,
	name = "航空攻击展示-芙米露露I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60341	};
	}
};
{
	id = 60342,
	name = "航空攻击展示-芙米露露II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60342	};
	}
};
{
	id = 60343,
	name = "航空攻击展示-芙米露露III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60343	};
	}
};
{
	id = 60351,
	name = "航空攻击展示-乌璐露I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60351	};
	}
};
{
	id = 60352,
	name = "航空攻击展示-乌璐露II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60352	};
	}
};
{
	id = 60353,
	name = "航空攻击展示-乌璐露III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60353	};
	}
};
{
	id = 60361,
	name = "航空攻击展示-萨拉娜I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60361	};
	}
};
{
	id = 60362,
	name = "航空攻击展示-萨拉娜II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60362	};
	}
};
{
	id = 60363,
	name = "航空攻击展示-萨拉娜III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60363	};
	}
};
{
	id = 60371,
	name = "航空攻击展示-龙骧I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60371	};
	}
};
{
	id = 60372,
	name = "航空攻击展示-龙骧II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60372	};
	}
};
{
	id = 60373,
	name = "航空攻击展示-龙骧III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60373	};
	}
};
{
	id = 60381,
	name = "航空攻击展示-追赶者I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60381	};
	}
};
{
	id = 60382,
	name = "航空攻击展示-追赶者II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60382	};
	}
};
{
	id = 60383,
	name = "航空攻击展示-追赶者III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60383	};
	}
};
{
	id = 60391,
	name = "航空攻击展示-独立I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60391	};
	}
};
{
	id = 60392,
	name = "航空攻击展示-独立II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60392	};
	}
};
{
	id = 60393,
	name = "航空攻击展示-独立III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60393	};
	}
};
{
	id = 60401,
	name = "航空攻击展示-爱酱I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60401	};
	}
};
{
	id = 60402,
	name = "航空攻击展示-爱酱II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60402	};
	}
};
{
	id = 60403,
	name = "航空攻击展示-爱酱III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60403	};
	}
};
{
	id = 60411,
	name = "航空攻击展示-小齐柏林I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60411	};
	}
};
{
	id = 60412,
	name = "航空攻击展示-小齐柏林II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60412	};
	}
};
{
	id = 60413,
	name = "航空攻击展示-小齐柏林III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60413	};
	}
};
{
	id = 60421,
	name = "航空攻击展示-可畏I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60421	};
	}
};
{
	id = 60422,
	name = "航空攻击展示-可畏II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60422	};
	}
};
{
	id = 60423,
	name = "航空攻击展示-可畏III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60423	};
	}
};
{
	id = 60431,
	name = "航空攻击展示-时乃空I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60431	};
	}
};
{
	id = 60432,
	name = "航空攻击展示-时乃空II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60432	};
	}
};
{
	id = 60433,
	name = "航空攻击展示-时乃空III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60433	};
	}
};
{
	id = 60441,
	name = "航空攻击展示-紫咲诗音I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60441	};
	}
};
{
	id = 60442,
	name = "航空攻击展示-紫咲诗音II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60442	};
	}
};
{
	id = 60443,
	name = "航空攻击展示-紫咲诗音III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60443	};
	}
};
{
	id = 60451,
	name = "航空攻击展示-大神澪I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60451	};
	}
};
{
	id = 60452,
	name = "航空攻击展示-大神澪II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60452	};
	}
};
{
	id = 60453,
	name = "航空攻击展示-大神澪III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60453	};
	}
};
{
	id = 60461,
	name = "航空攻击展示-白上吹雪III",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60461	};
	}
};
{
	id = 60471,
	name = "航空攻击展示-龙凤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60471	};
	}
};
{
	id = 60472,
	name = "航空攻击展示-龙凤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60472	};
	}
};
{
	id = 60473,
	name = "航空攻击展示-龙凤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60473	};
	}
};
{
	id = 60491,
	name = "航空攻击展示-卡萨布兰卡I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60491	};
	}
};
{
	id = 60492,
	name = "航空攻击展示-卡萨布兰卡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60492	};
	}
};
{
	id = 60493,
	name = "航空攻击展示-卡萨布兰卡III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60493	};
	}
};
{
	id = 60511,
	name = "航空攻击展示-贝亚恩I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60511	};
	}
};
{
	id = 60512,
	name = "航空攻击展示-贝亚恩II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60512	};
	}
};
{
	id = 60513,
	name = "航空攻击展示-贝亚恩III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60513	};
	}
};
{
	id = 60521,
	name = "航空攻击展示-英仙座I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60521	};
	}
};
{
	id = 60522,
	name = "航空攻击展示-英仙座II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60522	};
	}
};
{
	id = 60523,
	name = "航空攻击展示-英仙座III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60523	};
	}
};
{
	id = 60531,
	name = "航空攻击展示-鹰I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60531	};
	}
};
{
	id = 60532,
	name = "航空攻击展示-鹰II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60532	};
	}
};
{
	id = 60533,
	name = "航空攻击展示-鹰III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60533	};
	}
};
{
	id = 60541,
	name = "航空攻击展示-千岁I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60541	};
	}
};
{
	id = 60542,
	name = "航空攻击展示-千岁II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60542	};
	}
};
{
	id = 60543,
	name = "航空攻击展示-千岁III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60543	};
	}
};
{
	id = 60551,
	name = "航空攻击展示-千代田I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60551	};
	}
};
{
	id = 60552,
	name = "航空攻击展示-千代田II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60552	};
	}
};
{
	id = 60553,
	name = "航空攻击展示-千代田III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60553	};
	}
};
{
	id = 60561,
	name = "航空攻击展示-信浓I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60561	};
	}
};
{
	id = 60562,
	name = "航空攻击展示-信浓II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60562	};
	}
};
{
	id = 60563,
	name = "航空攻击展示-信浓III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60563	};
	}
};
{
	id = 60591,
	name = "航空攻击展示-威悉II",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60591	};
	}
};
{
	id = 60592,
	name = "航空攻击展示-威悉III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60592	};
		{	tech = 0, rarity = 0, id = 60593	};
	}
};
{
	id = 60601,
	name = "航空攻击展示-彼得史特拉塞I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60601	};
	}
};
{
	id = 60602,
	name = "航空攻击展示-彼得史特拉塞II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60602	};
	}
};
{
	id = 60603,
	name = "航空攻击展示-彼得史特拉塞III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60603	};
	}
};
{
	id = 60641,
	name = "航空攻击展示-天鹰I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60641	};
	}
};
{
	id = 60642,
	name = "航空攻击展示-天鹰II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60642	};
	}
};
{
	id = 60643,
	name = "航空攻击展示-天鹰III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60643	};
	}
};
{
	id = 60671,
	name = "航空攻击展示-白龙I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60671	};
	}
};
{
	id = 60672,
	name = "航空攻击展示-白龙II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60672	};
	}
};
{
	id = 60673,
	name = "航空攻击展示-白龙III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60673	};
	}
};
{
	id = 60681,
	name = "航空攻击展示-奥古斯特I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60681	};
	}
};
{
	id = 60682,
	name = "航空攻击展示-奥古斯特II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60682	};
	}
};
{
	id = 60683,
	name = "航空攻击展示-奥古斯特III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60683	};
	}
};
{
	id = 60711,
	name = "航空攻击展示-葛城I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60711	};
	}
};
{
	id = 60712,
	name = "航空攻击展示-葛城II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60712	};
		{	tech = 0, rarity = 0, id = 60713	};
	}
};
{
	id = 60751,
	name = "航空攻击展示-镇海I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60751	};
	}
};
{
	id = 60752,
	name = "航空攻击展示-镇海II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60752	};
		{	tech = 0, rarity = 0, id = 60753	};
	}
};
{
	id = 60781,
	name = "航空攻击展示-帝国I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60781	};
	}
};
{
	id = 60782,
	name = "航空攻击展示-帝国II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60782	};
	}
};
{
	id = 60783,
	name = "航空攻击展示-帝国III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60783	};
	}
};
{
	id = 60831,
	name = "航空攻击展示-霞飞I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60831	};
	}
};
{
	id = 60832,
	name = "航空攻击展示-霞飞II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60832	};
	}
};
{
	id = 60833,
	name = "航空攻击展示-霞飞III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60833	};
	}
};
{
	id = 60851,
	name = "航空攻击展示-契卡洛夫I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60851	};
	}
};
{
	id = 60852,
	name = "航空攻击展示-契卡洛夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60852	};
	}
};
{
	id = 60853,
	name = "航空攻击展示-契卡洛夫III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60853	};
	}
};
{
	id = 60911,
	name = "航空攻击展示-阿尔比恩I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60911	};
	}
};
{
	id = 60912,
	name = "航空攻击展示-阿尔比恩II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60912	};
	}
};
{
	id = 60913,
	name = "航空攻击展示-阿尔比恩III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60913	};
	}
};
{
	id = 60921,
	name = "航空攻击展示-华甲I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60921	};
	}
};
{
	id = 60922,
	name = "航空攻击展示-华甲II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60922	};
	}
};
{
	id = 60923,
	name = "航空攻击展示-华甲III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60923	};
	}
};
{
	id = 60931,
	name = "航空攻击展示-忒修斯I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60931	};
	}
};
{
	id = 60932,
	name = "航空攻击展示-忒修斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60932	};
	}
};
{
	id = 60933,
	name = "航空攻击展示-忒修斯III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60933	};
	}
};
{
	id = 60941,
	name = "航空攻击展示-定安I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60941	};
	}
};
{
	id = 60942,
	name = "航空攻击展示-定安II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60942	};
	}
};
{
	id = 60943,
	name = "航空攻击展示-定安III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60943	};
	}
};
{
	id = 60951,
	name = "航空攻击展示-怨仇I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60951	};
	}
};
{
	id = 60952,
	name = "航空攻击展示-怨仇II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60952	};
	}
};
{
	id = 60953,
	name = "航空攻击展示-怨仇III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60953	};
	}
};
{
	id = 60981,
	name = "航空攻击展示-露娜I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 60981	};
	}
};
{
	id = 60982,
	name = "航空攻击展示-露娜II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60982	};
	}
};
{
	id = 60983,
	name = "航空攻击展示-露娜III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 60983	};
	}
};
{
	id = 61007,
	name = "约克城技能随机扫射海面LV1",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61007	};
	}
};
{
	id = 61008,
	name = "约克城技能随机扫射海面LV2",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61008	};
	}
};
{
	id = 61009,
	name = "约克城技能随机扫射海面LV3",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61009	};
	}
};
{
	id = 61010,
	name = "皇家方舟技能LV1",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61010	};
	}
};
{
	id = 61011,
	name = "皇家方舟技能LV2",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61011	};
	}
};
{
	id = 61012,
	name = "皇家方舟技能LV3",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61012	};
	}
};
{
	id = 61031,
	name = "十姊妹展示",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61031	};
	}
};
{
	id = 61041,
	name = "夕星展示",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61041	};
	}
};
{
	id = 61051,
	name = "百合根1段展示",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61051	};
	}
};
{
	id = 61052,
	name = "百合根2段展示",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61052	};
	}
};
{
	id = 61053,
	name = "百合根3段展示",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61053	};
	}
};
{
	id = 61054,
	name = "百合根4段展示",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61054	};
	}
};
{
	id = 61061,
	name = "航空攻击展示-埃塞克斯-约克城I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61061	};
	}
};
{
	id = 61062,
	name = "航空攻击展示-埃塞克斯-约克城II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61062	};
		{	tech = 0, rarity = 0, id = 61063	};
	}
};
{
	id = 61071,
	name = "航空攻击展示-奇尔沙治I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61071	};
	}
};
{
	id = 61072,
	name = "航空攻击展示-奇尔沙治II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61072	};
	}
};
{
	id = 61073,
	name = "航空攻击展示-奇尔沙治III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61073	};
	}
};
{
	id = 61081,
	name = "航空攻击展示-雪泉I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61081	};
	}
};
{
	id = 61082,
	name = "航空攻击展示-雪泉II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61082	};
		{	tech = 0, rarity = 0, id = 61083	};
	}
};
{
	id = 61091,
	name = "航空攻击展示-纳希莫夫海军上将I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61091	};
	}
};
{
	id = 61092,
	name = "航空攻击展示-纳希莫夫海军上将II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61092	};
		{	tech = 0, rarity = 0, id = 61093	};
	}
};
{
	id = 61101,
	name = "航空攻击展示-哈尔福德I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61101	};
	}
};
{
	id = 61102,
	name = "航空攻击展示-哈尔福德II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61102	};
	}
};
{
	id = 61103,
	name = "航空攻击展示-瑞凤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61103	};
	}
};
{
	id = 61104,
	name = "航空攻击展示-瑞凤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61104	};
	}
};
{
	id = 61105,
	name = "航空攻击展示-瑞凤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61105	};
	}
};
{
	id = 61111,
	name = "航空攻击展示-天城I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61111	};
	}
};
{
	id = 61112,
	name = "航空攻击展示-天城II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61112	};
		{	tech = 0, rarity = 0, id = 61113	};
	}
};
{
	id = 61121,
	name = "航空攻击展示-弗里茨·鲁梅I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61121	};
	}
};
{
	id = 61122,
	name = "航空攻击展示-弗里茨·鲁梅II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61122	};
		{	tech = 0, rarity = 0, id = 61123	};
	}
};
{
	id = 61131,
	name = "航空攻击展示-白凤I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61131	};
	}
};
{
	id = 61132,
	name = "航空攻击展示-白凤II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61132	};
	}
};
{
	id = 61133,
	name = "航空攻击展示-白凤III",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61133	};
	}
};
{
	id = 61141,
	name = "航空攻击展示-i404I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61141	};
	}
};
{
	id = 61142,
	name = "航空攻击展示-i404II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61142	};
	}
};
{
	id = 61151,
	name = "航空攻击展示-鸢一折纸I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61151	};
	}
};
{
	id = 61152,
	name = "航空攻击展示-鸢一折纸II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61152	};
		{	tech = 0, rarity = 0, id = 61153	};
	}
};
{
	id = 61161,
	name = "航空攻击展示-四糸乃I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61161	};
	}
};
{
	id = 61162,
	name = "航空攻击展示-四糸乃II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61162	};
		{	tech = 0, rarity = 0, id = 61163	};
	}
};
{
	id = 61171,
	name = "航空攻击展示-埃塞克斯-列克星敦I",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61171	};
	}
};
{
	id = 61172,
	name = "航空攻击展示-埃塞克斯-列克星敦II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 61172	};
		{	tech = 0, rarity = 0, id = 61173	};
	}
};
{
	id = 61501,
	name = "轰炸机外观预览飞机",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61501	};
	}
};
{
	id = 61503,
	name = "鱼雷机外观预览飞机",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61503	};
	}
};
{
	id = 61504,
	name = "鱼雷机外观预览鱼雷",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61504	};
	}
};
{
	id = 61505,
	name = "战斗机外观预览飞机",
	type = 99,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 61505	};
	}
};
{
	id = 66200,
	name = "提尔比茨磁性鱼雷",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 66200	};
	}
};
{
	id = 66220,
	name = "沙恩霍斯特级鱼雷",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 66220	};
	}
};
{
	id = 70011,
	name = "全弹发射-法拉格特级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70011	};
	}
};
{
	id = 70012,
	name = "全弹发射-法拉格特级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70012	};
	}
};
{
	id = 70021,
	name = "全弹发射-马汉级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70021	};
	}
};
{
	id = 70022,
	name = "全弹发射-马汉级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70022	};
	}
};
{
	id = 70031,
	name = "全弹发射-格里德利级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70031	};
	}
};
{
	id = 70032,
	name = "全弹发射-格里德利级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70032	};
	}
};
{
	id = 70041,
	name = "全弹发射-弗莱彻级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70041	};
	}
};
{
	id = 70042,
	name = "全弹发射-弗莱彻级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70042	};
	}
};
{
	id = 70051,
	name = "全弹发射-西姆斯级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70051	};
	}
};
{
	id = 70052,
	name = "全弹发射-西姆斯级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70052	};
	}
};
{
	id = 70061,
	name = "全弹发射-本森级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70061	};
	}
};
{
	id = 70062,
	name = "全弹发射-本森级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70062	};
	}
};
{
	id = 70071,
	name = "全弹发射-基林级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70071	};
	}
};
{
	id = 70072,
	name = "全弹发射-基林级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70072	};
	}
};
{
	id = 70081,
	name = "全弹发射-艾伦·萨姆那级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70081	};
	}
};
{
	id = 70082,
	name = "全弹发射-艾伦·萨姆那级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70082	};
	}
};
{
	id = 70091,
	name = "全弹发射-埃德索尔级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70091	};
	}
};
{
	id = 70092,
	name = "全弹发射-埃德索尔级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70092	};
	}
};
{
	id = 70111,
	name = "全弹发射-奥马哈级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70111	};
	}
};
{
	id = 70112,
	name = "全弹发射-奥马哈级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70112	};
	}
};
{
	id = 70121,
	name = "全弹发射-布鲁克林级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70121	};
	}
};
{
	id = 70122,
	name = "全弹发射-布鲁克林级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70122	};
	}
};
{
	id = 70131,
	name = "全弹发射-亚特兰大级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70131	};
	}
};
{
	id = 70132,
	name = "全弹发射-亚特兰大级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70132	};
	}
};
{
	id = 70141,
	name = "全弹发射-克利夫兰级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70141	};
	}
};
{
	id = 70142,
	name = "全弹发射-克利夫兰级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70142	};
	}
};
{
	id = 70211,
	name = "全弹发射-彭萨科拉级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70211	};
	}
};
{
	id = 70212,
	name = "全弹发射-彭萨科拉级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70212	};
	}
};
{
	id = 70221,
	name = "全弹发射-北安普顿级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70221	};
	}
};
{
	id = 70222,
	name = "全弹发射-北安普顿级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70222	};
	}
};
{
	id = 70231,
	name = "全弹发射-波特兰级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70231	};
	}
};
{
	id = 70232,
	name = "全弹发射-波特兰级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70232	};
	}
};
{
	id = 70241,
	name = "全弹发射-新奥尔良级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70241	};
	}
};
{
	id = 70242,
	name = "全弹发射-新奥尔良级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70242	};
	}
};
{
	id = 70251,
	name = "全弹发射-威奇塔I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70251	};
	}
};
{
	id = 70252,
	name = "全弹发射-威奇塔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70252	};
	}
};
{
	id = 70261,
	name = "全弹发射-巴尔的摩级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70261	};
	}
};
{
	id = 70262,
	name = "全弹发射-巴尔的摩级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70262	};
	}
};
{
	id = 70271,
	name = "全弹发射-得梅因级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70271	};
	}
};
{
	id = 70272,
	name = "全弹发射-得梅因级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70272	};
	}
};
{
	id = 70281,
	name = "全弹发射-俄勒冈城级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70281	};
	}
};
{
	id = 70282,
	name = "全弹发射-俄勒冈城级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70282	};
	}
};
{
	id = 70311,
	name = "全弹发射-猫鲨级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70311	};
	}
};
{
	id = 70312,
	name = "全弹发射-猫鲨级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70312	};
	}
};
{
	id = 70321,
	name = "全弹发射-独角鲸级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 70321	};
	}
};
{
	id = 70322,
	name = "全弹发射-独角鲸级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 70322	};
	}
};
{
	id = 71011,
	name = "全弹发射-A级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71011	};
	}
};
{
	id = 71012,
	name = "全弹发射-A级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71012	};
	}
};
{
	id = 71016,
	name = "全弹发射-部族级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71016	};
	}
};
{
	id = 71017,
	name = "全弹发射-部族级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71017	};
	}
};
{
	id = 71021,
	name = "全弹发射-B级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71021	};
	}
};
{
	id = 71022,
	name = "全弹发射-B级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71022	};
	}
};
{
	id = 71026,
	name = "全弹发射-I级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71026	};
	}
};
{
	id = 71027,
	name = "全弹发射-I级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71027	};
	}
};
{
	id = 71031,
	name = "全弹发射-C级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71031	};
	}
};
{
	id = 71032,
	name = "全弹发射-C级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71032	};
	}
};
{
	id = 71041,
	name = "全弹发射-F级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71041	};
	}
};
{
	id = 71042,
	name = "全弹发射-F级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71042	};
	}
};
{
	id = 71051,
	name = "全弹发射-G级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71051	};
	}
};
{
	id = 71052,
	name = "全弹发射-G级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71052	};
	}
};
{
	id = 71061,
	name = "全弹发射-H级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71061	};
	}
};
{
	id = 71062,
	name = "全弹发射-H级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71062	};
	}
};
{
	id = 71071,
	name = "全弹发射-J级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71071	};
	}
};
{
	id = 71072,
	name = "全弹发射-J级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71072	};
	}
};
{
	id = 71081,
	name = "全弹发射-M级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71081	};
	}
};
{
	id = 71082,
	name = "全弹发射-M级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71082	};
	}
};
{
	id = 71091,
	name = "全弹发射-E级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71091	};
	}
};
{
	id = 71092,
	name = "全弹发射-E级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71092	};
	}
};
{
	id = 71111,
	name = "全弹发射-利安得级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71111	};
	}
};
{
	id = 71112,
	name = "全弹发射-利安得级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71112	};
	}
};
{
	id = 71121,
	name = "全弹发射-黛朵级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71121	};
	}
};
{
	id = 71122,
	name = "全弹发射-黛朵级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71122	};
	}
};
{
	id = 71131,
	name = "全弹发射-阿瑞托莎级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71131	};
	}
};
{
	id = 71132,
	name = "全弹发射-阿瑞托莎级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71132	};
	}
};
{
	id = 71141,
	name = "全弹发射-爱丁堡级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71141	};
	}
};
{
	id = 71142,
	name = "全弹发射-爱丁堡级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71142	};
	}
};
{
	id = 71151,
	name = "全弹发射-南安普顿级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71151	};
	}
};
{
	id = 71152,
	name = "全弹发射-南安普顿级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71152	};
	}
};
{
	id = 71161,
	name = "全弹发射-斐济级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71161	};
	}
};
{
	id = 71162,
	name = "全弹发射-斐济级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71162	};
	}
};
{
	id = 71171,
	name = "全弹发射-谷物女神级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71171	};
	}
};
{
	id = 71172,
	name = "全弹发射-谷物女神级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71172	};
	}
};
{
	id = 71181,
	name = "全弹发射-格罗斯特级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71181	};
	}
};
{
	id = 71182,
	name = "全弹发射-格罗斯特级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71182	};
	}
};
{
	id = 71191,
	name = "全弹发射-翡翠级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71191	};
	}
};
{
	id = 71192,
	name = "全弹发射-翡翠级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71192	};
	}
};
{
	id = 71211,
	name = "全弹发射-伦敦级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71211	};
	}
};
{
	id = 71212,
	name = "全弹发射-伦敦级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71212	};
	}
};
{
	id = 71221,
	name = "全弹发射-肯特级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71221	};
	}
};
{
	id = 71222,
	name = "全弹发射-肯特级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71222	};
	}
};
{
	id = 71231,
	name = "全弹发射-诺福克级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71231	};
	}
};
{
	id = 71232,
	name = "全弹发射-诺福克级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71232	};
	}
};
{
	id = 71241,
	name = "全弹发射-约克级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 71241	};
	}
};
{
	id = 71242,
	name = "全弹发射-约克级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 71242	};
	}
};
{
	id = 72011,
	name = "全弹发射-睦月级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72011	};
	}
};
{
	id = 72012,
	name = "全弹发射-睦月级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72012	};
	}
};
{
	id = 72021,
	name = "全弹发射-吹雪级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72021	};
	}
};
{
	id = 72022,
	name = "全弹发射-吹雪级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72022	};
	}
};
{
	id = 72031,
	name = "全弹发射-白露级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72031	};
	}
};
{
	id = 72032,
	name = "全弹发射-白露级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72032	};
	}
};
{
	id = 72041,
	name = "全弹发射-初春级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72041	};
	}
};
{
	id = 72042,
	name = "全弹发射-初春级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72042	};
	}
};
{
	id = 72051,
	name = "全弹发射-阳炎级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72051	};
	}
};
{
	id = 72052,
	name = "全弹发射-阳炎级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72052	};
	}
};
{
	id = 72056,
	name = "全弹发射-夕云级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72056	};
	}
};
{
	id = 72057,
	name = "全弹发射-夕云级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72057	};
	}
};
{
	id = 72061,
	name = "全弹发射-秋月级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72061	};
	}
};
{
	id = 72062,
	name = "全弹发射-秋月级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72062	};
	}
};
{
	id = 72071,
	name = "全弹发射-晓级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72071	};
	}
};
{
	id = 72072,
	name = "全弹发射-晓级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72072	};
	}
};
{
	id = 72081,
	name = "全弹发射-神风级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72081	};
	}
};
{
	id = 72082,
	name = "全弹发射-神风级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72082	};
	}
};
{
	id = 72091,
	name = "全弹发射-朝潮级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72091	};
	}
};
{
	id = 72092,
	name = "全弹发射-朝潮级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72092	};
	}
};
{
	id = 72111,
	name = "全弹发射-天龙级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72111	};
	}
};
{
	id = 72112,
	name = "全弹发射-天龙级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72112	};
	}
};
{
	id = 72121,
	name = "全弹发射-球磨级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72121	};
	}
};
{
	id = 72122,
	name = "全弹发射-球磨级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72122	};
	}
};
{
	id = 72131,
	name = "全弹发射-川内级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72131	};
	}
};
{
	id = 72132,
	name = "全弹发射-川内级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72132	};
	}
};
{
	id = 72141,
	name = "全弹发射-长良级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72141	};
	}
};
{
	id = 72142,
	name = "全弹发射-长良级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72142	};
	}
};
{
	id = 72151,
	name = "全弹发射-阿贺野级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72151	};
	}
};
{
	id = 72152,
	name = "全弹发射-阿贺野级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72152	};
	}
};
{
	id = 72161,
	name = "全弹发射-夕张I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72161	};
	}
};
{
	id = 72162,
	name = "全弹发射-夕张II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72162	};
	}
};
{
	id = 72211,
	name = "全弹发射-古鹰级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72211	};
	}
};
{
	id = 72212,
	name = "全弹发射-古鹰级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72212	};
	}
};
{
	id = 72221,
	name = "全弹发射-青叶级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72221	};
	}
};
{
	id = 72222,
	name = "全弹发射-青叶级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72222	};
	}
};
{
	id = 72231,
	name = "全弹发射-妙高级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72231	};
	}
};
{
	id = 72232,
	name = "全弹发射-妙高级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72232	};
	}
};
{
	id = 72241,
	name = "全弹发射-利根级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72241	};
		{	tech = 1, rarity = 1, id = 72271	};
	}
};
{
	id = 72242,
	name = "全弹发射-利根级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72242	};
		{	tech = 0, rarity = 0, id = 72272	};
	}
};
{
	id = 72251,
	name = "全弹发射-最上级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72251	};
	}
};
{
	id = 72252,
	name = "全弹发射-最上级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72252	};
	}
};
{
	id = 72254,
	name = "全弹发射-最上级铃谷型I",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72254	};
	}
};
{
	id = 72255,
	name = "全弹发射-最上级铃谷型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72255	};
	}
};
{
	id = 72256,
	name = "全弹发射-最上级铃谷型I增强",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72256	};
	}
};
{
	id = 72257,
	name = "全弹发射-最上级铃谷型II增强",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72257	};
	}
};
{
	id = 72261,
	name = "全弹发射-高雄级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72261	};
	}
};
{
	id = 72262,
	name = "全弹发射-高雄级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72262	};
	}
};
{
	id = 72281,
	name = "全弹发射-伊吹级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72281	};
	}
};
{
	id = 72282,
	name = "全弹发射-伊吹级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72282	};
	}
};
{
	id = 72311,
	name = "全弹发射-伊乙级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72311	};
	}
};
{
	id = 72312,
	name = "全弹发射-伊乙级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72312	};
	}
};
{
	id = 72411,
	name = "全弹发射-樫野I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 72411	};
	}
};
{
	id = 72412,
	name = "全弹发射-樫野II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 72412	};
	}
};
{
	id = 73011,
	name = "全弹发射-1934型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73011	};
	}
};
{
	id = 73012,
	name = "全弹发射-1934型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73012	};
	}
};
{
	id = 73021,
	name = "全弹发射-1934A型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73021	};
	}
};
{
	id = 73022,
	name = "全弹发射-1934A型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73022	};
	}
};
{
	id = 73031,
	name = "全弹发射-1936型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73031	};
	}
};
{
	id = 73032,
	name = "全弹发射-1936型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73032	};
	}
};
{
	id = 73041,
	name = "全弹发射-1936A型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73041	};
	}
};
{
	id = 73042,
	name = "全弹发射-1936A型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73042	};
	}
};
{
	id = 73051,
	name = "全弹发射-1936B型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73051	};
	}
};
{
	id = 73052,
	name = "全弹发射-1936B型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73052	};
	}
};
{
	id = 73111,
	name = "全弹发射-柯尼斯堡级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73111	};
	}
};
{
	id = 73112,
	name = "全弹发射-柯尼斯堡级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73112	};
	}
};
{
	id = 73121,
	name = "全弹发射-莱比锡级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73121	};
	}
};
{
	id = 73122,
	name = "全弹发射-莱比锡级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73122	};
	}
};
{
	id = 73131,
	name = "全弹发射-皮劳级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73131	};
	}
};
{
	id = 73132,
	name = "全弹发射-皮劳级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73132	};
	}
};
{
	id = 73211,
	name = "全弹发射-希佩尔海军上将级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73211	};
	}
};
{
	id = 73212,
	name = "全弹发射-希佩尔海军上将级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73212	};
	}
};
{
	id = 73221,
	name = "全弹发射-德意志级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73221	};
	}
};
{
	id = 73222,
	name = "全弹发射-德意志级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73222	};
	}
};
{
	id = 73231,
	name = "全弹发射-P级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73231	};
	}
};
{
	id = 73232,
	name = "全弹发射-P级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73232	};
	}
};
{
	id = 73241,
	name = "全弹发射-罗恩级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73241	};
	}
};
{
	id = 73242,
	name = "全弹发射-罗恩级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73242	};
	}
};
{
	id = 73311,
	name = "全弹发射-Type VIIC型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73311	};
	}
};
{
	id = 73312,
	name = "全弹发射-Type VIIC型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73312	};
	}
};
{
	id = 73321,
	name = "全弹发射-Type IXB型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73321	};
	}
};
{
	id = 73322,
	name = "全弹发射-Type IXB型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73322	};
	}
};
{
	id = 73411,
	name = "全弹发射-Type VIIB型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73411	};
	}
};
{
	id = 73412,
	name = "全弹发射-Type VIIB型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73412	};
	}
};
{
	id = 73511,
	name = "全弹发射-Type IXC型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73511	};
	}
};
{
	id = 73512,
	name = "全弹发射-Type IXC型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73512	};
	}
};
{
	id = 73611,
	name = "全弹发射-Type VIIA型I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 73611	};
	}
};
{
	id = 73612,
	name = "全弹发射-Type VIIA型II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 73612	};
	}
};
{
	id = 74011,
	name = "全弹发射-鞍山级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74011	};
	}
};
{
	id = 74012,
	name = "全弹发射-鞍山级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74012	};
	}
};
{
	id = 74023,
	name = "全弹发射-青龙III",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74023	};
	}
};
{
	id = 74031,
	name = "全弹发射-龙武I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74031	};
	}
};
{
	id = 74032,
	name = "全弹发射-龙武II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74032	};
	}
};
{
	id = 74033,
	name = "全弹发射-朱雀III",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74033	};
	}
};
{
	id = 74041,
	name = "全弹发射-虎贲I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74041	};
	}
};
{
	id = 74042,
	name = "全弹发射-虎贲II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74042	};
	}
};
{
	id = 74043,
	name = "全弹发射-白虎III",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74043	};
	}
};
{
	id = 74053,
	name = "全弹发射-玄武III",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74053	};
	}
};
{
	id = 74061,
	name = "全弹发射-飞云I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74061	};
	}
};
{
	id = 74062,
	name = "全弹发射-飞云II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74062	};
	}
};
{
	id = 74111,
	name = "全弹发射-宁海级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74111	};
	}
};
{
	id = 74112,
	name = "全弹发射-宁海级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74112	};
	}
};
{
	id = 74121,
	name = "全弹发射-逸仙I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74121	};
	}
};
{
	id = 74122,
	name = "全弹发射-逸仙II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74122	};
	}
};
{
	id = 74131,
	name = "全弹发射-肇和级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74131	};
	}
};
{
	id = 74132,
	name = "全弹发射-肇和级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74132	};
	}
};
{
	id = 74141,
	name = "全弹发射-海天级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74141	};
	}
};
{
	id = 74142,
	name = "全弹发射-海天级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74142	};
	}
};
{
	id = 74151,
	name = "全弹发射-济安I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74151	};
	}
};
{
	id = 74152,
	name = "全弹发射-济安II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74152	};
	}
};
{
	id = 74161,
	name = "全弹发射-海容级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 74161	};
	}
};
{
	id = 74162,
	name = "全弹发射-海容级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 74162	};
	}
};
{
	id = 75011,
	name = "全弹发射-索尔达蒂级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75011	};
	}
};
{
	id = 75012,
	name = "全弹发射-索尔达蒂级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75012	};
	}
};
{
	id = 75021,
	name = "全弹发射-诗人级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75021	};
	}
};
{
	id = 75022,
	name = "全弹发射-诗人级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75022	};
	}
};
{
	id = 75031,
	name = "全弹发射-西北风级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75031	};
	}
};
{
	id = 75032,
	name = "全弹发射-西北风级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75032	};
	}
};
{
	id = 75041,
	name = "全弹发射-航海家级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75041	};
	}
};
{
	id = 75042,
	name = "全弹发射-航海家级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75042	};
	}
};
{
	id = 75111,
	name = "全弹发射-朱塞诺级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75111	};
	}
};
{
	id = 75112,
	name = "全弹发射-朱塞诺级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75112	};
	}
};
{
	id = 75211,
	name = "全弹发射-特伦托级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75211	};
	}
};
{
	id = 75212,
	name = "全弹发射-特伦托级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75212	};
	}
};
{
	id = 75221,
	name = "全弹发射-扎拉级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75221	};
	}
};
{
	id = 75222,
	name = "全弹发射-扎拉级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75222	};
	}
};
{
	id = 75231,
	name = "全弹发射-博尔扎诺级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75231	};
	}
};
{
	id = 75232,
	name = "全弹发射-博尔扎诺级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75232	};
	}
};
{
	id = 75511,
	name = "全弹发射-布林级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 75511	};
	}
};
{
	id = 75512,
	name = "全弹发射-布林级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 75512	};
	}
};
{
	id = 76011,
	name = "全弹发射-愤怒级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 76011	};
	}
};
{
	id = 76012,
	name = "全弹发射-愤怒级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 76012	};
	}
};
{
	id = 76021,
	name = "全弹发射-明斯克级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 76021	};
	}
};
{
	id = 76022,
	name = "全弹发射-明斯克级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 76022	};
	}
};
{
	id = 76031,
	name = "全弹发射-前哨级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 76031	};
	}
};
{
	id = 76032,
	name = "全弹发射-前哨级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 76032	};
	}
};
{
	id = 76111,
	name = "全弹发射-博加特里级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 76111	};
	}
};
{
	id = 76112,
	name = "全弹发射-博加特里级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 76112	};
	}
};
{
	id = 78011,
	name = "全弹发射-机敏级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78011	};
	}
};
{
	id = 78012,
	name = "全弹发射-机敏级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78012	};
	}
};
{
	id = 78021,
	name = "全弹发射-大胆级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78021	};
	}
};
{
	id = 78022,
	name = "全弹发射-大胆级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78022	};
	}
};
{
	id = 78031,
	name = "全弹发射-沃克兰级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78031	};
	}
};
{
	id = 78032,
	name = "全弹发射-沃克兰级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78032	};
	}
};
{
	id = 78101,
	name = "全弹发射-迪盖·特鲁因级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78101	};
	}
};
{
	id = 78102,
	name = "全弹发射-迪盖·特鲁因级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78102	};
	}
};
{
	id = 78111,
	name = "全弹发射-埃米尔·贝尔汀I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78111	};
	}
};
{
	id = 78112,
	name = "全弹发射-埃米尔·贝尔汀II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78112	};
	}
};
{
	id = 78121,
	name = "全弹发射-拉·加利索尼埃I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78121	};
	}
};
{
	id = 78122,
	name = "全弹发射-拉·加利索尼埃II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78122	};
	}
};
{
	id = 78211,
	name = "全弹发射-阿尔及利亚I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78211	};
	}
};
{
	id = 78212,
	name = "全弹发射-阿尔及利亚II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78212	};
	}
};
{
	id = 78221,
	name = "全弹发射-絮弗伦级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 78221	};
	}
};
{
	id = 78222,
	name = "全弹发射-絮弗伦级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 78222	};
	}
};
{
	id = 79011,
	name = "专属弹幕-英格兰I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79011	};
	}
};
{
	id = 79012,
	name = "专属弹幕-英格兰II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79012	};
	}
};
{
	id = 79021,
	name = "专属弹幕-埃尔德里奇I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79021	};
	}
};
{
	id = 79022,
	name = "专属弹幕-埃尔德里奇II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79022	};
	}
};
{
	id = 79031,
	name = "专属弹幕-威廉·D·波特I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79031	};
	}
};
{
	id = 79032,
	name = "专属弹幕-威廉·D·波特II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79032	};
	}
};
{
	id = 79041,
	name = "专属弹幕-约翰斯顿I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79041	};
	}
};
{
	id = 79042,
	name = "专属弹幕-约翰斯顿II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79042	};
	}
};
{
	id = 79051,
	name = "专属弹幕-拉菲I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79051	};
		{	tech = 1, rarity = 1, id = 80081	};
	}
};
{
	id = 79052,
	name = "专属弹幕-拉菲II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79052	};
		{	tech = 0, rarity = 0, id = 80082	};
	}
};
{
	id = 79061,
	name = "专属弹幕-萤火虫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79061	};
	}
};
{
	id = 79062,
	name = "专属弹幕-萤火虫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79062	};
	}
};
{
	id = 79071,
	name = "专属弹幕-勇敢I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79071	};
	}
};
{
	id = 79072,
	name = "专属弹幕-勇敢II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79072	};
	}
};
{
	id = 79081,
	name = "专属弹幕-标枪I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79081	};
	}
};
{
	id = 79082,
	name = "专属弹幕-标枪II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79082	};
	}
};
{
	id = 79091,
	name = "专属弹幕-吸血鬼I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79091	};
	}
};
{
	id = 79092,
	name = "专属弹幕-吸血鬼II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79092	};
	}
};
{
	id = 79101,
	name = "专属弹幕-贝尔法斯特I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79101	};
	}
};
{
	id = 79102,
	name = "专属弹幕-贝尔法斯特II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79102	};
	}
};
{
	id = 79111,
	name = "专属弹幕-绫波I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79111	};
	}
};
{
	id = 79112,
	name = "专属弹幕-绫波II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79112	};
	}
};
{
	id = 79121,
	name = "专属弹幕-夕立I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79121	};
	}
};
{
	id = 79122,
	name = "专属弹幕-夕立II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79122	};
	}
};
{
	id = 79131,
	name = "专属弹幕-雪风I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79131	};
	}
};
{
	id = 79132,
	name = "专属弹幕-雪风II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79132	};
	}
};
{
	id = 79141,
	name = "专属弹幕-岛风I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79141	};
		{	tech = 1, rarity = 1, id = 79771	};
	}
};
{
	id = 79142,
	name = "专属弹幕-岛风II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79142	};
		{	tech = 0, rarity = 0, id = 79772	};
	}
};
{
	id = 79151,
	name = "专属弹幕-北上I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79151	};
	}
};
{
	id = 79152,
	name = "专属弹幕-北上II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79152	};
	}
};
{
	id = 79161,
	name = "专属弹幕-大井I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79161	};
	}
};
{
	id = 79162,
	name = "专属弹幕-大井II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79162	};
	}
};
{
	id = 79171,
	name = "专属弹幕-Z1I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79171	};
	}
};
{
	id = 79172,
	name = "专属弹幕-Z1II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79172	};
	}
};
{
	id = 79181,
	name = "专属弹幕-鞍山I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79181	};
	}
};
{
	id = 79182,
	name = "专属弹幕-鞍山II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79182	};
	}
};
{
	id = 79191,
	name = "专属弹幕-阿芙乐尔I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79191	};
	}
};
{
	id = 79192,
	name = "专属弹幕-阿芙乐尔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79192	};
	}
};
{
	id = 79201,
	name = "专属弹幕-Z23I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79201	};
	}
};
{
	id = 79202,
	name = "专属弹幕-Z23II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79202	};
	}
};
{
	id = 79211,
	name = "专属弹幕-Z46I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79211	};
	}
};
{
	id = 79212,
	name = "专属弹幕-Z46II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79212	};
	}
};
{
	id = 79221,
	name = "专属弹幕-伊吹I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79221	};
	}
};
{
	id = 79222,
	name = "专属弹幕-伊吹II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79222	};
	}
};
{
	id = 79231,
	name = "专属弹幕-海王星I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79231	};
	}
};
{
	id = 79232,
	name = "专属弹幕-海王星II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79232	};
	}
};
{
	id = 79241,
	name = "专属弹幕-罗恩I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79241	};
	}
};
{
	id = 79242,
	name = "专属弹幕-罗恩II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79242	};
	}
};
{
	id = 79251,
	name = "专属弹幕-路易九世I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79251	};
	}
};
{
	id = 79252,
	name = "专属弹幕-路易九世II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79252	};
	}
};
{
	id = 79261,
	name = "专属弹幕-I19I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79261	};
	}
};
{
	id = 79262,
	name = "专属弹幕-I19II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79262	};
	}
};
{
	id = 79271,
	name = "专属弹幕-U81I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79271	};
	}
};
{
	id = 79272,
	name = "专属弹幕-U81II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79272	};
	}
};
{
	id = 79291,
	name = "专属弹幕-22I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79291	};
	}
};
{
	id = 79292,
	name = "专属弹幕-22II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79292	};
	}
};
{
	id = 79301,
	name = "专属弹幕-33I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79301	};
	}
};
{
	id = 79302,
	name = "专属弹幕-33II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79302	};
	}
};
{
	id = 79311,
	name = "专属弹幕-U47I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79311	};
	}
};
{
	id = 79312,
	name = "专属弹幕-U47II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79312	};
	}
};
{
	id = 79321,
	name = "专属弹幕-絮库夫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79321	};
	}
};
{
	id = 79322,
	name = "专属弹幕-絮库夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79322	};
	}
};
{
	id = 79331,
	name = "专属弹幕-凯旋I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79331	};
	}
};
{
	id = 79332,
	name = "专属弹幕-凯旋II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79332	};
	}
};
{
	id = 79341,
	name = "专属弹幕-大青花鱼I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79341	};
	}
};
{
	id = 79342,
	name = "专属弹幕-大青花鱼II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79342	};
	}
};
{
	id = 79361,
	name = "专属弹幕-天狼星I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79361	};
	}
};
{
	id = 79362,
	name = "专属弹幕-天狼星II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79362	};
	}
};
{
	id = 79371,
	name = "专属弹幕-I13I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79371	};
	}
};
{
	id = 79372,
	name = "专属弹幕-I13II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79372	};
	}
};
{
	id = 79381,
	name = "专属弹幕-北风I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79381	};
	}
};
{
	id = 79382,
	name = "专属弹幕-北风II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79382	};
	}
};
{
	id = 79383,
	name = "专属弹幕鱼雷-北风I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79383	};
	}
};
{
	id = 79384,
	name = "专属弹幕鱼雷-北风II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79384	};
	}
};
{
	id = 79391,
	name = "专属弹幕-西雅图I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79391	};
	}
};
{
	id = 79392,
	name = "专属弹幕-西雅图II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79392	};
	}
};
{
	id = 79401,
	name = "专属弹幕-确捷I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79401	};
	}
};
{
	id = 79402,
	name = "专属弹幕-确捷II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79402	};
	}
};
{
	id = 79411,
	name = "专属弹幕-恶毒I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79411	};
	}
};
{
	id = 79412,
	name = "专属弹幕-恶毒II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79412	};
	}
};
{
	id = 79421,
	name = "专属弹幕-I168I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79421	};
	}
};
{
	id = 79422,
	name = "专属弹幕-I168II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79422	};
	}
};
{
	id = 79431,
	name = "专属弹幕-U101I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79431	};
	}
};
{
	id = 79432,
	name = "专属弹幕-U101II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79432	};
	}
};
{
	id = 79441,
	name = "专属弹幕-棘鳍I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79441	};
	}
};
{
	id = 79442,
	name = "专属弹幕-棘鳍II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79442	};
	}
};
{
	id = 79451,
	name = "全弹发射-克利夫兰μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79451	};
	}
};
{
	id = 79452,
	name = "全弹发射-克利夫兰μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79452	};
	}
};
{
	id = 79461,
	name = "全弹发射-南安普顿μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79461	};
	}
};
{
	id = 79462,
	name = "全弹发射-南安普顿μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79462	};
	}
};
{
	id = 79471,
	name = "全弹发射-希佩尔海军上将μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79471	};
	}
};
{
	id = 79472,
	name = "全弹发射-希佩尔海军上将μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79472	};
	}
};
{
	id = 79481,
	name = "专属弹幕-能代I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79481	};
	}
};
{
	id = 79482,
	name = "专属弹幕-能代II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79482	};
	}
};
{
	id = 79491,
	name = "专属弹幕-黛朵I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79491	};
	}
};
{
	id = 79492,
	name = "专属弹幕-黛朵II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79492	};
	}
};
{
	id = 79501,
	name = "专属弹幕-塔什干I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79501	};
	}
};
{
	id = 79502,
	name = "专属弹幕-塔什干II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79502	};
	}
};
{
	id = 79511,
	name = "专属弹幕-恰巴耶夫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79511	};
	}
};
{
	id = 79512,
	name = "专属弹幕-恰巴耶夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79512	};
	}
};
{
	id = 79521,
	name = "专属弹幕-里诺I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79521	};
	}
};
{
	id = 79522,
	name = "专属弹幕-里诺II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79522	};
	}
};
{
	id = 79541,
	name = "专属弹幕-圣女贞德I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79541	};
	}
};
{
	id = 79542,
	name = "专属弹幕-圣女贞德II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79542	};
	}
};
{
	id = 79551,
	name = "专属弹幕-柴郡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79551	};
	}
};
{
	id = 79552,
	name = "专属弹幕-柴郡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79552	};
	}
};
{
	id = 79561,
	name = "专属弹幕-德雷克I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79561	};
	}
};
{
	id = 79562,
	name = "专属弹幕-德雷克II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79562	};
	}
};
{
	id = 79571,
	name = "专属弹幕-美因茨I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79571	};
	}
};
{
	id = 79572,
	name = "专属弹幕-美因茨II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79572	};
	}
};
{
	id = 79581,
	name = "专属弹幕-赫敏I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79581	};
	}
};
{
	id = 79582,
	name = "专属弹幕-赫敏II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79582	};
	}
};
{
	id = 79591,
	name = "专属弹幕-U96I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79591	};
	}
};
{
	id = 79592,
	name = "专属弹幕-U96II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79592	};
	}
};
{
	id = 79601,
	name = "专属弹幕-凉月I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79601	};
	}
};
{
	id = 79602,
	name = "专属弹幕-凉月II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79602	};
	}
};
{
	id = 79611,
	name = "专属弹幕-罗恩μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79611	};
	}
};
{
	id = 79612,
	name = "专属弹幕-罗恩μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79612	};
	}
};
{
	id = 79621,
	name = "专属弹幕-恶毒μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79621	};
	}
};
{
	id = 79622,
	name = "专属弹幕-恶毒μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79622	};
	}
};
{
	id = 79631,
	name = "专属弹幕-黛朵μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79631	};
	}
};
{
	id = 79632,
	name = "专属弹幕-黛朵μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79632	};
	}
};
{
	id = 79641,
	name = "专属弹幕-塔什干μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79641	};
	}
};
{
	id = 79642,
	name = "专属弹幕-塔什干μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79642	};
	}
};
{
	id = 79651,
	name = "专属弹幕-大青花鱼μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79651	};
	}
};
{
	id = 79652,
	name = "专属弹幕-大青花鱼μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79652	};
	}
};
{
	id = 79661,
	name = "专属弹幕-巴尔的摩μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79661	};
	}
};
{
	id = 79662,
	name = "专属弹幕-巴尔的摩μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79662	};
	}
};
{
	id = 79671,
	name = "专属弹幕-U37I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79671	};
	}
};
{
	id = 79672,
	name = "专属弹幕-U37II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79672	};
	}
};
{
	id = 79681,
	name = "专属弹幕-基洛夫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79681	};
	}
};
{
	id = 79682,
	name = "专属弹幕-基洛夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79682	};
	}
};
{
	id = 79691,
	name = "专属弹幕-艾伦萨姆纳I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79691	};
	}
};
{
	id = 79692,
	name = "专属弹幕-艾伦萨姆纳II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79692	};
	}
};
{
	id = 79701,
	name = "专属弹幕-阿布鲁齐公爵I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79701	};
	}
};
{
	id = 79702,
	name = "专属弹幕-阿布鲁齐公爵II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79702	};
	}
};
{
	id = 79711,
	name = "专属弹幕-旧金山I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79711	};
	}
};
{
	id = 79712,
	name = "专属弹幕-旧金山II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79712	};
	}
};
{
	id = 79721,
	name = "专属弹幕-射水鱼I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79721	};
	}
};
{
	id = 79722,
	name = "专属弹幕-射水鱼II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79722	};
	}
};
{
	id = 79731,
	name = "专属弹幕-海伦娜.META I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79731	};
	}
};
{
	id = 79732,
	name = "专属弹幕-海伦娜.META II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79732	};
	}
};
{
	id = 79741,
	name = "专属弹幕-风云I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79741	};
	}
};
{
	id = 79742,
	name = "专属弹幕-风云II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79742	};
	}
};
{
	id = 79751,
	name = "专属弹幕-安克雷奇I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79751	};
	}
};
{
	id = 79752,
	name = "专属弹幕-安克雷奇II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79752	};
	}
};
{
	id = 79761,
	name = "专属弹幕-英格拉罕I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79761	};
	}
};
{
	id = 79762,
	name = "专属弹幕-英格拉罕II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79762	};
	}
};
{
	id = 79781,
	name = "专属弹幕-可怖I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79781	};
	}
};
{
	id = 79782,
	name = "专属弹幕-可怖II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79782	};
	}
};
{
	id = 79791,
	name = "专属弹幕-马格德堡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79791	};
	}
};
{
	id = 79792,
	name = "专属弹幕-马格德堡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79792	};
	}
};
{
	id = 79801,
	name = "专属弹幕-卡律布狄斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79801	};
	}
};
{
	id = 79802,
	name = "专属弹幕-卡律布狄斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79802	};
	}
};
{
	id = 79811,
	name = "专属弹幕-布里斯托尔I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79811	};
	}
};
{
	id = 79812,
	name = "专属弹幕-布里斯托尔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79812	};
	}
};
{
	id = 79821,
	name = "专属弹幕-基辅I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79821	};
	}
};
{
	id = 79822,
	name = "专属弹幕-基辅II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79822	};
	}
};
{
	id = 79831,
	name = "专属弹幕-庞培·马格诺I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79831	};
	}
};
{
	id = 79832,
	name = "专属弹幕-庞培·马格诺II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79832	};
	}
};
{
	id = 79841,
	name = "专属弹幕-埃姆登I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79841	};
	}
};
{
	id = 79842,
	name = "专属弹幕-埃姆登II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79842	};
	}
};
{
	id = 79851,
	name = "专属弹幕-贾维斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79851	};
	}
};
{
	id = 79852,
	name = "专属弹幕-贾维斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79852	};
	}
};
{
	id = 79861,
	name = "专属弹幕-小柴郡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79861	};
	}
};
{
	id = 79862,
	name = "专属弹幕-小柴郡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79862	};
	}
};
{
	id = 79871,
	name = "专属弹幕-孟菲斯.META I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79871	};
	}
};
{
	id = 79872,
	name = "专属弹幕-孟菲斯.META II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79872	};
	}
};
{
	id = 79881,
	name = "专属弹幕-不屈I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79881	};
	}
};
{
	id = 79882,
	name = "专属弹幕-不屈II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79882	};
	}
};
{
	id = 79891,
	name = "专属弹幕-普利茅斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79891	};
	}
};
{
	id = 79892,
	name = "专属弹幕-普利茅斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79892	};
	}
};
{
	id = 79893,
	name = "专属弹幕-普利茅斯II鱼雷",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79893	};
	}
};
{
	id = 79901,
	name = "专属弹幕-哈尔滨I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79901	};
	}
};
{
	id = 79902,
	name = "专属弹幕-哈尔滨II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79902	};
	}
};
{
	id = 79903,
	name = "专属弹幕-哈尔滨鱼雷",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79903	};
	}
};
{
	id = 79911,
	name = "专属弹幕-朱塞佩.加里波第I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79911	};
	}
};
{
	id = 79912,
	name = "专属弹幕-朱塞佩.加里波第II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79912	};
	}
};
{
	id = 79921,
	name = "专属弹幕-莱昂纳多·达·芬奇I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79921	};
	}
};
{
	id = 79922,
	name = "专属弹幕-莱昂纳多·达·芬奇II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79922	};
	}
};
{
	id = 79931,
	name = "专属弹幕-特伦托.METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79931	};
	}
};
{
	id = 79932,
	name = "专属弹幕-特伦托.METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79932	};
	}
};
{
	id = 79941,
	name = "专属弹幕-酒匂I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79941	};
	}
};
{
	id = 79942,
	name = "专属弹幕-酒匂II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79942	};
	}
};
{
	id = 79951,
	name = "专属弹幕-若月I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79951	};
	}
};
{
	id = 79952,
	name = "专属弹幕-若月II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79952	};
	}
};
{
	id = 79961,
	name = "专属弹幕-猎人METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79961	};
	}
};
{
	id = 79962,
	name = "专属弹幕-猎人METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79962	};
	}
};
{
	id = 79971,
	name = "专属弹幕-雅努斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79971	};
	}
};
{
	id = 79972,
	name = "专属弹幕-雅努斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79972	};
	}
};
{
	id = 79981,
	name = "专属弹幕-皇家财富I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79981	};
	}
};
{
	id = 79982,
	name = "专属弹幕-皇家财富II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79982	};
	}
};
{
	id = 79991,
	name = "专属弹幕-命运女神METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 79991	};
	}
};
{
	id = 79992,
	name = "专属弹幕-命运女神METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 79992	};
	}
};
{
	id = 80001,
	name = "专属弹幕-雷根斯堡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80001	};
	}
};
{
	id = 80002,
	name = "专属弹幕-雷根斯堡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80002	};
	}
};
{
	id = 80011,
	name = "专属弹幕-阿尔及利亚.METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80011	};
	}
};
{
	id = 80012,
	name = "专属弹幕-阿尔及利亚.METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80012	};
	}
};
{
	id = 80021,
	name = "专属弹幕-阿蒂利奥·雷戈洛I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80021	};
	}
};
{
	id = 80022,
	name = "专属弹幕-阿蒂利奥·雷戈洛II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80022	};
	}
};
{
	id = 80031,
	name = "专属弹幕-菲利克斯·舒尔茨I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80031	};
	}
};
{
	id = 80032,
	name = "专属弹幕-菲利克斯·舒尔茨II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80032	};
	}
};
{
	id = 80033,
	name = "专属弹幕鱼雷-菲利克斯·舒尔茨II",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80033	};
	}
};
{
	id = 80041,
	name = "专属弹幕-吉尚I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80041	};
	}
};
{
	id = 80042,
	name = "专属弹幕-吉尚II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80042	};
	}
};
{
	id = 80051,
	name = "专属弹幕-云仙I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80051	};
	}
};
{
	id = 80052,
	name = "专属弹幕-云仙II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80052	};
	}
};
{
	id = 80061,
	name = "专属弹幕-初月I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80061	};
	}
};
{
	id = 80062,
	name = "专属弹幕-初月II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80062	};
	}
};
{
	id = 80071,
	name = "专属弹幕-金鹿号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80071	};
	}
};
{
	id = 80072,
	name = "专属弹幕-金鹿号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80072	};
	}
};
{
	id = 80073,
	name = "专属弹幕-加里冒险号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80073	};
	}
};
{
	id = 80074,
	name = "专属弹幕-加里冒险号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80074	};
	}
};
{
	id = 80091,
	name = "专属弹幕-松鲷I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80091	};
	}
};
{
	id = 80092,
	name = "专属弹幕-松鲷II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80092	};
	}
};
{
	id = 80101,
	name = "专属弹幕-金伯利METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80101	};
	}
};
{
	id = 80102,
	name = "专属弹幕-金伯利METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80102	};
	}
};
{
	id = 80201,
	name = "专属弹幕-火力I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80201	};
	}
};
{
	id = 80202,
	name = "专属弹幕-火力II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80202	};
	}
};
{
	id = 80211,
	name = "专属弹幕-努比亚人I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80211	};
	}
};
{
	id = 80212,
	name = "专属弹幕-努比亚人II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80212	};
	}
};
{
	id = 80221,
	name = "专属弹幕-吸血鬼METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80221	};
	}
};
{
	id = 80222,
	name = "专属弹幕-吸血鬼METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80222	};
	}
};
{
	id = 80231,
	name = "专属弹幕-{namecode:532}I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80231	};
	}
};
{
	id = 80232,
	name = "专属弹幕-{namecode:532}II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80232	};
	}
};
{
	id = 80241,
	name = "专属弹幕-鲁莽(μ兵装)I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80241	};
	}
};
{
	id = 80242,
	name = "专属弹幕-鲁莽(μ兵装)II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80242	};
	}
};
{
	id = 80251,
	name = "专属弹幕-能代μI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80251	};
	}
};
{
	id = 80252,
	name = "专属弹幕-能代μII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80252	};
	}
};
{
	id = 80253,
	name = "专属弹幕-能代μ鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80253	};
	}
};
{
	id = 80261,
	name = "专属弹幕-莫加多尔I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80261	};
	}
};
{
	id = 80262,
	name = "专属弹幕-莫加多尔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80262	};
	}
};
{
	id = 80271,
	name = "专属弹幕-布伦努斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80271	};
	}
};
{
	id = 80272,
	name = "专属弹幕-布伦努斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80272	};
	}
};
{
	id = 80281,
	name = "专属弹幕-福煦METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80281	};
	}
};
{
	id = 80282,
	name = "专属弹幕-福煦METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80282	};
	}
};
{
	id = 80291,
	name = "专属弹幕-威奇塔METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80291	};
	}
};
{
	id = 80292,
	name = "专属弹幕-威奇塔METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80292	};
	}
};
{
	id = 80301,
	name = "专属弹幕-Z47I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80301	};
	}
};
{
	id = 80302,
	name = "专属弹幕-Z47II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80302	};
	}
};
{
	id = 80311,
	name = "专属弹幕-贝亚德I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80311	};
	}
};
{
	id = 80312,
	name = "专属弹幕-贝亚德II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80312	};
	}
};
{
	id = 80321,
	name = "专属弹幕-哈尔福德I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80321	};
	}
};
{
	id = 80322,
	name = "专属弹幕-哈尔福德II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80322	};
	}
};
{
	id = 80331,
	name = "专属弹幕-果敢I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80331	};
	}
};
{
	id = 80332,
	name = "专属弹幕-果敢II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80332	};
	}
};
{
	id = 80341,
	name = "专属弹幕-法戈I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80341	};
	}
};
{
	id = 80342,
	name = "专属弹幕-法戈II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80342	};
	}
};
{
	id = 80351,
	name = "专属弹幕-渡良濑I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80351	};
	}
};
{
	id = 80352,
	name = "专属弹幕-渡良濑II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80352	};
	}
};
{
	id = 80361,
	name = "专属弹幕-和睦I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80361	};
	}
};
{
	id = 80362,
	name = "专属弹幕-和睦II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80362	};
	}
};
{
	id = 80371,
	name = "专属弹幕-幻想号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80371	};
	}
};
{
	id = 80372,
	name = "专属弹幕-幻想号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80372	};
	}
};
{
	id = 80381,
	name = "专属弹幕-海豚I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80381	};
	}
};
{
	id = 80382,
	name = "专属弹幕-海豚II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80382	};
	}
};
{
	id = 80391,
	name = "专属弹幕-朴茨茅斯冒险号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80391	};
	}
};
{
	id = 80392,
	name = "专属弹幕-朴茨茅斯冒险号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80392	};
	}
};
{
	id = 80401,
	name = "专属弹幕-希佩尔METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80401	};
	}
};
{
	id = 80402,
	name = "专属弹幕-希佩尔METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80402	};
	}
};
{
	id = 80411,
	name = "专属弹幕-杜伊斯堡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80411	};
	}
};
{
	id = 80412,
	name = "专属弹幕-杜伊斯堡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80412	};
	}
};
{
	id = 80421,
	name = "专属弹幕-建武I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80421	};
	}
};
{
	id = 80422,
	name = "专属弹幕-建武II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80422	};
	}
};
{
	id = 80431,
	name = "专属弹幕-博尔扎诺METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80431	};
	}
};
{
	id = 80432,
	name = "专属弹幕-博尔扎诺METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80432	};
	}
};
{
	id = 80441,
	name = "专属弹幕-巴拉卡少校I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80441	};
	}
};
{
	id = 80442,
	name = "专属弹幕-巴拉卡少校II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80442	};
	}
};
{
	id = 80451,
	name = "全弹发射-海军上将级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80451	};
	}
};
{
	id = 80452,
	name = "全弹发射-海军上将级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80452	};
	}
};
{
	id = 80461,
	name = "专属弹幕-七省I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80461	};
	}
};
{
	id = 80462,
	name = "专属弹幕-七省II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80462	};
	}
};
{
	id = 80471,
	name = "专属弹幕-小安克雷奇I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80471	};
	}
};
{
	id = 80472,
	name = "专属弹幕-小安克雷奇II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80472	};
	}
};
{
	id = 80481,
	name = "专属弹幕-U552I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80481	};
	}
};
{
	id = 80482,
	name = "专属弹幕-U552II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80482	};
	}
};
{
	id = 80491,
	name = "专属弹幕-库尼贝尔蒂I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80491	};
	}
};
{
	id = 80492,
	name = "专属弹幕-库尼贝尔蒂II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80492	};
	}
};
{
	id = 80501,
	name = "专属弹幕-迪米特里·顿斯科伊I",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80501	};
	}
};
{
	id = 80502,
	name = "专属弹幕-迪米特里·顿斯科伊II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80502	};
	}
};
{
	id = 80511,
	name = "专属弹幕-大胆I",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80511	};
	}
};
{
	id = 80512,
	name = "专属弹幕-大胆II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80512	};
	}
};
{
	id = 80521,
	name = "专属弹幕-伊404I",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80521	};
	}
};
{
	id = 80522,
	name = "专属弹幕-伊404II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80522	};
	}
};
{
	id = 80531,
	name = "专属弹幕-夕立METAI",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80531	};
	}
};
{
	id = 80532,
	name = "专属弹幕-夕立METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80532	};
	}
};
{
	id = 80541,
	name = "专属弹幕-莱姆号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80541	};
	}
};
{
	id = 80542,
	name = "专属弹幕-莱姆号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80542	};
	}
};
{
	id = 80551,
	name = "专属弹幕-克利夫兰METAⅠ",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80551	};
	}
};
{
	id = 80552,
	name = "专属弹幕-克利夫兰METAⅠⅠ",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80552	};
	}
};
{
	id = 80561,
	name = "专属弹幕-威廉D波特I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80561	};
	}
};
{
	id = 80562,
	name = "专属弹幕-威廉D波特II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80562	};
	}
};
{
	id = 80571,
	name = "专属弹幕-藤波I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80571	};
	}
};
{
	id = 80572,
	name = "专属弹幕-藤波II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80572	};
	}
};
{
	id = 80581,
	name = "专属弹幕-龙骑兵META I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80581	};
	}
};
{
	id = 80582,
	name = "专属弹幕-龙骑兵META II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80582	};
	}
};
{
	id = 80591,
	name = "专属弹幕-彰武I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 80591	};
	}
};
{
	id = 80592,
	name = "专属弹幕-彰武II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 80592	};
	}
};
{
	id = 85000,
	name = "B-13 双联装130mm主炮B-2LM",
	type = 1,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 85000	};
		{	tech = 3, rarity = 5, id = 85040	};
	}
};
{
	id = 85060,
	name = "100mm双联装防空炮SM-5-1s",
	type = 6,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 85060	};
	}
};
{
	id = 85120,
	name = "B-38 三联装152mm主炮Mk5",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 85120	};
		{	tech = 2, rarity = 4, id = 85140	};
		{	tech = 3, rarity = 5, id = 85160	};
	}
};
{
	id = 85180,
	name = "37mm防空炮70-K",
	type = 6,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 85180	};
		{	tech = 2, rarity = 3, id = 85200	};
		{	tech = 3, rarity = 4, id = 85220	};
	}
};
{
	id = 85260,
	name = "B-54 100mm双联装防空炮",
	type = 6,
	nationality = 7,
	sub_equips = {
		{	tech = 2, rarity = 3, id = 85260	};
		{	tech = 3, rarity = 4, id = 85280	};
	}
};
{
	id = 85300,
	name = "B-37 三联装406mm主炮Mk-1",
	type = 4,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 85300	};
		{	tech = 2, rarity = 4, id = 85320	};
		{	tech = 3, rarity = 5, id = 85340	};
	}
};
{
	id = 85360,
	name = "B-34 100mm双联装防空炮MZ-14",
	type = 6,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 85360	};
		{	tech = 2, rarity = 3, id = 85380	};
		{	tech = 3, rarity = 4, id = 85400	};
	}
};
{
	id = 85420,
	name = "三联装305mm主炮Model1907",
	type = 4,
	nationality = 7,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 85420	};
	}
};
{
	id = 85440,
	name = "双联装152mm主炮Model1892",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 85440	};
	}
};
{
	id = 85460,
	name = "B-1-P 三联装180mm主炮Model1932",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 85460	};
		{	tech = 2, rarity = 4, id = 85480	};
		{	tech = 3, rarity = 5, id = 85500	};
	}
};
{
	id = 85520,
	name = "B-50 三联装305mm主炮Mk-15",
	type = 11,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85520	};
	}
};
{
	id = 85540,
	name = "试作舰载型Su-2",
	type = 9,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85540	};
	}
};
{
	id = 85560,
	name = "试作型VIT-2 (VK-107)",
	type = 8,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85560	};
	}
};
{
	id = 85580,
	name = "试作型三联装240mm主炮",
	type = 3,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85580	};
	}
};
{
	id = 85600,
	name = "试作舰载型La-9",
	type = 7,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 85600	};
	}
};
{
	id = 85620,
	name = "试作型VIT-2（模式调整）",
	type = 8,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85620	};
	}
};
{
	id = 85640,
	name = "试作型B-1-P 三联装180mm主炮Model1932改",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85640	};
	}
};
{
	id = 85660,
	name = "试作舰载型Su-6",
	type = 9,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 85660	};
	}
};
{
	id = 85680,
	name = "B-1-K 单装180mm主炮",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 85680	};
	}
};
{
	id = 85700,
	name = "B-38 双联装152mm主炮MK17",
	type = 2,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 85700	};
	}
};
{
	id = 85720,
	name = "130mm单装炮Model1913",
	type = 1,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 85720	};
	}
};
{
	id = 85740,
	name = "三联装356mm主炮Model1913",
	type = 4,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 85740	};
	}
};
{
	id = 85760,
	name = "R-5轰炸机",
	type = 9,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 85760	};
	}
};
{
	id = 85780,
	name = "LBSh",
	type = 9,
	nationality = 7,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 85780	};
	}
};
{
	id = 89000,
	name = "随机单词生成器",
	type = 10,
	nationality = 104,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89000	};
	}
};
{
	id = 89020,
	name = "晃悠悠",
	type = 10,
	nationality = 104,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89020	};
	}
};
{
	id = 89040,
	name = "智慧模块",
	type = 10,
	nationality = 104,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89040	};
	}
};
{
	id = 89060,
	name = "组徽",
	type = 10,
	nationality = 105,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89060	};
	}
};
{
	id = 89080,
	name = "Gamers的证明",
	type = 10,
	nationality = 105,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89080	};
	}
};
{
	id = 89100,
	name = "玉米灯笼",
	type = 10,
	nationality = 105,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89100	};
	}
};
{
	id = 89120,
	name = "鮟鱇肝",
	type = 10,
	nationality = 105,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89120	};
	}
};
{
	id = 89140,
	name = "炽烈之歌",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89140	};
	}
};
{
	id = 89160,
	name = "活力之歌",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89160	};
	}
};
{
	id = 89180,
	name = "闪耀之歌",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89180	};
	}
};
{
	id = 89200,
	name = "引力舞鞋",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89200	};
	}
};
{
	id = 89220,
	name = "星云舞裙",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89220	};
	}
};
{
	id = 89240,
	name = "觉醒宝珠",
	type = 10,
	nationality = 106,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89240	};
	}
};
{
	id = 89260,
	name = "心之钥匙",
	type = 10,
	nationality = 106,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89260	};
	}
};
{
	id = 89280,
	name = "偶像手环",
	type = 10,
	nationality = 107,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89280	};
	}
};
{
	id = 89300,
	name = "征战巨坦",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89300	};
	}
};
{
	id = 89320,
	name = "古立特圣剑",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89320	};
	}
};
{
	id = 89340,
	name = "爆裂钻孔机",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89340	};
	}
};
{
	id = 89360,
	name = "苍穹喷射机",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89360	};
	}
};
{
	id = 89380,
	name = "戴拿爆能加农",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89380	};
	}
};
{
	id = 89400,
	name = "煌翼炎龙",
	type = 10,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89400	};
	}
};
{
	id = 89420,
	name = "炙烈炎烧",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89420	};
	}
};
{
	id = 89440,
	name = "结晶冰精",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89440	};
	}
};
{
	id = 89460,
	name = "震耳雷球",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89460	};
	}
};
{
	id = 89480,
	name = "涡旋风精",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89480	};
	}
};
{
	id = 89500,
	name = "万灵药剂",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89500	};
	}
};
{
	id = 89520,
	name = "神秘的羽衣",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89520	};
	}
};
{
	id = 89540,
	name = "默示录",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89540	};
	}
};
{
	id = 89560,
	name = "Ｎ／Ａ",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89560	};
	}
};
{
	id = 89580,
	name = "创世之槌",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89580	};
	}
};
{
	id = 89600,
	name = "泡云弹车",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89600	};
	}
};
{
	id = 89620,
	name = "形意口琴",
	type = 10,
	nationality = 109,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89620	};
	}
};
{
	id = 89640,
	name = "帝王蟹（附带小票）",
	type = 18,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89640	};
	}
};
{
	id = 89660,
	name = "木龙雕塑",
	type = 18,
	nationality = 108,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89660	};
	}
};
{
	id = 89680,
	name = "忍者大师徽章",
	type = 10,
	nationality = 110,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89680	};
	}
};
{
	id = 89700,
	name = "忍者装束",
	type = 10,
	nationality = 110,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89700	};
	}
};
{
	id = 89720,
	name = "忍术卷轴",
	type = 10,
	nationality = 110,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89720	};
	}
};
{
	id = 89740,
	name = "μ兵装三期LIVE纪念票",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89740	};
	}
};
{
	id = 89760,
	name = "「Alizarin」应援毛巾",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89760	};
	}
};
{
	id = 89780,
	name = "「Cyanidin」应援毛巾",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 89780	};
	}
};
{
	id = 90000,
	name = "130mm单装炮Mle1924",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 90000	};
		{	tech = 2, rarity = 2, id = 90020	};
		{	tech = 3, rarity = 3, id = 90040	};
	}
};
{
	id = 90100,
	name = "138.6mm单装炮Mle1929",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 90100	};
		{	tech = 2, rarity = 4, id = 90120	};
		{	tech = 3, rarity = 5, id = 90140	};
	}
};
{
	id = 90160,
	name = "双联装138.6mm主炮Mle1934",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 90160	};
	}
};
{
	id = 90200,
	name = "三联装152mm主炮Mle1930",
	type = 2,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 90200	};
		{	tech = 2, rarity = 2, id = 90220	};
		{	tech = 3, rarity = 3, id = 90240	};
	}
};
{
	id = 90260,
	name = "三联装152mm主炮Mle1930(高爆弹)",
	type = 2,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 90260	};
	}
};
{
	id = 90300,
	name = "四联装330mm主炮Mle1931",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 90300	};
		{	tech = 2, rarity = 3, id = 90320	};
		{	tech = 3, rarity = 4, id = 90340	};
	}
};
{
	id = 90360,
	name = "试作型四联装330mm主炮Mle1931（超巡用）",
	type = 11,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 90360	};
	}
};
{
	id = 90400,
	name = "四联装380mm主炮Mle1935",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 90400	};
		{	tech = 2, rarity = 4, id = 90420	};
		{	tech = 3, rarity = 5, id = 90440	};
	}
};
{
	id = 90460,
	name = "四联装340mm主炮Mle1912",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 90460	};
	}
};
{
	id = 90480,
	name = "试作型三联装380mm主炮Mle1935",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 90480	};
	}
};
{
	id = 90500,
	name = "双联装130mm主炮Mle1935",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 90500	};
		{	tech = 3, rarity = 4, id = 90540	};
	}
};
{
	id = 90560,
	name = "37mm高射炮Mle1925",
	type = 6,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 90560	};
	}
};
{
	id = 90580,
	name = "双联37mm高射炮Mle1933",
	type = 6,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 90580	};
	}
};
{
	id = 90600,
	name = "双联37mm高射炮Mle1936",
	type = 6,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 90600	};
	}
};
{
	id = 90620,
	name = "双联装57mm/L60博福斯对空机炮Mle1951",
	type = 6,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 90620	};
	}
};
{
	id = 90700,
	name = "138.6mm单装炮Mle1927",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 90700	};
		{	tech = 2, rarity = 3, id = 90720	};
		{	tech = 3, rarity = 4, id = 90740	};
	}
};
{
	id = 90760,
	name = "138.6mm单装炮Mle1923",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 90760	};
	}
};
{
	id = 90780,
	name = "双联装155mm主炮Mle1920",
	type = 2,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 90780	};
	}
};
{
	id = 90800,
	name = "单装155mm副炮Mle1920",
	type = 2,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 90800	};
	}
};
{
	id = 90820,
	name = "GL.2舰载战斗机",
	type = 7,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 90820	};
	}
};
{
	id = 90840,
	name = "PL.7舰载鱼雷机",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 90840	};
	}
};
{
	id = 90860,
	name = "双联装203mm主炮Mle1931",
	type = 3,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 90860	};
		{	tech = 2, rarity = 4, id = 90880	};
		{	tech = 3, rarity = 5, id = 90900	};
	}
};
{
	id = 91000,
	name = "试作型三联装406mm/50主炮",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 91000	};
	}
};
{
	id = 91100,
	name = "双联装203mm主炮Mle1924",
	type = 3,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 91100	};
		{	tech = 3, rarity = 4, id = 91140	};
	}
};
{
	id = 91180,
	name = "FBA 19",
	type = 12,
	nationality = 8,
	sub_equips = {
		{	tech = 2, rarity = 3, id = 91180	};
		{	tech = 3, rarity = 4, id = 91200	};
	}
};
{
	id = 91220,
	name = "D.790",
	type = 7,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 91220	};
	}
};
{
	id = 91240,
	name = "BR.810",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 91240	};
	}
};
{
	id = 91260,
	name = "天使之羽",
	type = 10,
	nationality = 10,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 91260	};
	}
};
{
	id = 91280,
	name = "十字胸针",
	type = 10,
	nationality = 10,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 91280	};
	}
};
{
	id = 91300,
	name = "PL.10",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 91300	};
	}
};
{
	id = 91320,
	name = "V-156-F",
	type = 9,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 91320	};
	}
};
{
	id = 91340,
	name = "LN.401",
	type = 9,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 91340	};
	}
};
{
	id = 91360,
	name = "Late.299",
	type = 8,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 91360	};
	}
};
{
	id = 91380,
	name = "LGL.32",
	type = 7,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 91380	};
	}
};
{
	id = 95000,
	name = "三联装381mm主炮Model1934",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95000	};
		{	tech = 2, rarity = 4, id = 95020	};
		{	tech = 3, rarity = 5, id = 95040	};
	}
};
{
	id = 95100,
	name = "90mm单装高角炮Model1939",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95100	};
		{	tech = 2, rarity = 4, id = 95120	};
		{	tech = 3, rarity = 5, id = 95140	};
	}
};
{
	id = 95160,
	name = "试作型双联90mm高角炮Model1939",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 95160	};
	}
};
{
	id = 95200,
	name = "双联203mm主炮Model1927",
	type = 3,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95200	};
		{	tech = 2, rarity = 4, id = 95220	};
		{	tech = 3, rarity = 5, id = 95240	};
	}
};
{
	id = 95300,
	name = "双联203mm主炮Model1924",
	type = 3,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 95300	};
		{	tech = 2, rarity = 3, id = 95320	};
		{	tech = 3, rarity = 4, id = 95340	};
	}
};
{
	id = 95400,
	name = "双联装120mm炮Model1936",
	type = 1,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 95400	};
		{	tech = 2, rarity = 3, id = 95420	};
		{	tech = 3, rarity = 4, id = 95440	};
	}
};
{
	id = 95460,
	name = "双联装120mm炮Model1933",
	type = 1,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 95460	};
	}
};
{
	id = 95480,
	name = "三联装320mm主炮Model1934",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 95480	};
	}
};
{
	id = 95500,
	name = "双联37mm机枪Model1932",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 95500	};
		{	tech = 2, rarity = 3, id = 95520	};
		{	tech = 3, rarity = 4, id = 95540	};
	}
};
{
	id = 95600,
	name = "三联装152mm主炮Model1934",
	type = 2,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95600	};
	}
};
{
	id = 95640,
	name = "三联装152mm主炮Model1934 ",
	type = 2,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 95640	};
	}
};
{
	id = 95660,
	name = "试作型三联装152mm主炮Model1936",
	type = 2,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 95660	};
	}
};
{
	id = 95700,
	name = "潜艇用533mm鱼雷Si 270",
	type = 13,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95700	};
	}
};
{
	id = 95720,
	name = "G.50箭式战斗机",
	type = 7,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 95720	};
		{	tech = 2, rarity = 3, id = 95740	};
		{	tech = 3, rarity = 4, id = 95760	};
	}
};
{
	id = 95800,
	name = "Re.2001公羊",
	type = 7,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 95800	};
		{	tech = 2, rarity = 3, id = 95820	};
		{	tech = 3, rarity = 4, id = 95840	};
	}
};
{
	id = 95900,
	name = "试作型三联装406mm主炮Model1940",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 95900	};
	}
};
{
	id = 95920,
	name = "双联装135mm主炮Model1938",
	type = 1,
	nationality = 6,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 95920	};
		{	tech = 2, rarity = 4, id = 95940	};
		{	tech = 3, rarity = 5, id = 95960	};
	}
};
{
	id = 96000,
	name = "上游-1",
	type = 20,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96000	};
	}
};
{
	id = 96020,
	name = "上游-1甲",
	type = 20,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96020	};
	}
};
{
	id = 96100,
	name = "试作型双联装130mm主炮Model1936",
	type = 1,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96100	};
	}
};
{
	id = 96120,
	name = "试作型三联装254mm主炮Model1939",
	type = 3,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96120	};
	}
};
{
	id = 96140,
	name = "三联装305mm主炮Model1909",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 96140	};
	}
};
{
	id = 96160,
	name = "双联装381mm主炮Model1914",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 96160	};
	}
};
{
	id = 96180,
	name = "双联装Breda13.2mm高炮",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 3, id = 96180	};
	}
};
{
	id = 96200,
	name = "单装65mmModel1939高炮",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 96200	};
	}
};
{
	id = 96220,
	name = "双联装Breda20mm高炮",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 96220	};
	}
};
{
	id = 96240,
	name = "试作型三联装406mm主炮Model1940改",
	type = 4,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 6, id = 96240	};
	}
};
{
	id = 96260,
	name = "试作型六联装Scotti20mm机炮Model1941",
	type = 6,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96260	};
	}
};
{
	id = 96280,
	name = "试作型四联装533毫米鱼雷Si 270",
	type = 5,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 96280	};
	}
};
{
	id = 100000,
	name = "装备模板",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 100000	};
	}
};
{
	id = 150000,
	name = "刺绣锦囊",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150000	};
	}
};
{
	id = 150020,
	name = "飓风旗",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150020	};
	}
};
{
	id = 150040,
	name = "旧式重火炮",
	type = 1,
	nationality = 96,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 150040	};
		{	tech = 3, rarity = 5, id = 150080	};
	}
};
{
	id = 150100,
	name = "旧式半加农炮",
	type = 4,
	nationality = 96,
	sub_equips = {
		{	tech = 1, rarity = 3, id = 150100	};
		{	tech = 3, rarity = 5, id = 150140	};
	}
};
{
	id = 150160,
	name = "果蔬补给品",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150160	};
	}
};
{
	id = 150180,
	name = "航海望远镜",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150180	};
	}
};
{
	id = 150200,
	name = "星海B2O区通行证",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150200	};
	}
};
{
	id = 150240,
	name = "寰昌的钓鱼竿",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150240	};
	}
};
{
	id = 150260,
	name = "通天之匣",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150260	};
	}
};
{
	id = 150280,
	name = "异世界冒险终端",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150280	};
	}
};
{
	id = 150300,
	name = "被定格的彼岸花",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150300	};
	}
};
{
	id = 150320,
	name = "奇怪装置「D」",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150320	};
	}
};
{
	id = 150340,
	name = "联合演习纪念币（限定版）",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150340	};
	}
};
{
	id = 150360,
	name = "速运高速无人机",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150360	};
	}
};
{
	id = 150380,
	name = "珍贵货物箱",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150380	};
	}
};
{
	id = 150400,
	name = "葡萄弹",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150400	};
	}
};
{
	id = 150420,
	name = "酒饮补给品",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150420	};
	}
};
{
	id = 150440,
	name = "咻咻料理君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150440	};
	}
};
{
	id = 150460,
	name = "嗡嗡倾听君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150460	};
	}
};
{
	id = 150480,
	name = "嘘嘘隐身君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150480	};
	}
};
{
	id = 150500,
	name = "嘻嘻加班君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150500	};
	}
};
{
	id = 150520,
	name = "嘭嘭速生君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150520	};
	}
};
{
	id = 150540,
	name = "噗噗氛围君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150540	};
	}
};
{
	id = 150560,
	name = "辉辉光环君",
	type = 10,
	nationality = 111,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150560	};
	}
};
{
	id = 150580,
	name = "孟菲斯之蓝",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150580	};
	}
};
{
	id = 150600,
	name = "伏波的计划书",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150600	};
	}
};
{
	id = 150620,
	name = "黑日之冕",
	type = 10,
	nationality = 6,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150620	};
	}
};
{
	id = 150640,
	name = "郁金香花束",
	type = 10,
	nationality = 11,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150640	};
	}
};
{
	id = 150660,
	name = "我的宝贝鲸鱼",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150660	};
	}
};
{
	id = 150680,
	name = "宏伟光辉",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150680	};
	}
};
{
	id = 150700,
	name = "高级魔导书",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150700	};
	}
};
{
	id = 150720,
	name = "最终陨石",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150720	};
	}
};
{
	id = 150740,
	name = "神药球",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150740	};
	}
};
{
	id = 150760,
	name = "地狱立方体",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150760	};
	}
};
{
	id = 150780,
	name = "天恩浑仪",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150780	};
	}
};
{
	id = 150800,
	name = "芙拉米",
	type = 10,
	nationality = 113,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150800	};
	}
};
{
	id = 150820,
	name = "重樱的邀请函",
	type = 10,
	nationality = 3,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150820	};
	}
};
{
	id = 150840,
	name = "自由群岛邀请函",
	type = 10,
	nationality = 96,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150840	};
	}
};
{
	id = 150860,
	name = "<封解主（Michael）>",
	type = 10,
	nationality = 115,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150860	};
	}
};
{
	id = 150880,
	name = "灵结晶",
	type = 10,
	nationality = 115,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150880	};
	}
};
{
	id = 150900,
	name = "超大饭团",
	type = 10,
	nationality = 115,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 150900	};
	}
};
{
	id = 150920,
	name = "海蓝色之谜",
	type = 10,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150920	};
	}
};
{
	id = 150940,
	name = "导演的剧本书",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150940	};
	}
};
{
	id = 150960,
	name = "拍卖会请柬 ",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150960	};
	}
};
{
	id = 150980,
	name = "香蝶戏竹",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 150980	};
	}
};
{
	id = 151000,
	name = "香蝶弄梅",
	type = 10,
	nationality = 5,
	sub_equips = {
		{	tech = 0, rarity = 4, id = 151000	};
	}
};
{
	id = 170001,
	name = "专属弹幕-古比雪夫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170001	};
	}
};
{
	id = 170002,
	name = "专属弹幕-古比雪夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170002	};
	}
};
{
	id = 170011,
	name = "专属弹幕-谢菲尔德METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170011	};
	}
};
{
	id = 170012,
	name = "专属弹幕-谢菲尔德METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170012	};
	}
};
{
	id = 170021,
	name = "专属弹幕-斯库拉I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170021	};
	}
};
{
	id = 170022,
	name = "专属弹幕-斯库拉II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170022	};
	}
};
{
	id = 170031,
	name = "专属弹幕-库尔斯克I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170031	};
	}
};
{
	id = 170032,
	name = "专属弹幕-库尔斯克II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170032	};
	}
};
{
	id = 170041,
	name = "专属弹幕-拉·加利索尼埃METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170041	};
	}
};
{
	id = 170042,
	name = "专属弹幕-拉·加利索尼埃METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170042	};
	}
};
{
	id = 170051,
	name = "专属弹幕-伏罗希洛夫I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170051	};
	}
};
{
	id = 170052,
	name = "专属弹幕-伏罗希洛夫II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170052	};
	}
};
{
	id = 170061,
	name = "专属弹幕-奥托·冯·阿尔文斯莱本I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170061	};
	}
};
{
	id = 170062,
	name = "专属弹幕-奥托·冯·阿尔文斯莱本II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170062	};
	}
};
{
	id = 170071,
	name = "专属弹幕-U-556METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170071	};
	}
};
{
	id = 170072,
	name = "专属弹幕-U-556METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170072	};
	}
};
{
	id = 170121,
	name = "专属弹幕-兴登堡I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170121	};
	}
};
{
	id = 170122,
	name = "专属弹幕-兴登堡II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170122	};
	}
};
{
	id = 170131,
	name = "专属弹幕-四万十I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170131	};
	}
};
{
	id = 170132,
	name = "专属弹幕-四万十II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170132	};
	}
};
{
	id = 170133,
	name = "专属弹幕-四万十鱼雷",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170133	};
	}
};
{
	id = 170141,
	name = "专属弹幕-旗风METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170141	};
	}
};
{
	id = 170142,
	name = "专属弹幕-旗风METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170142	};
	}
};
{
	id = 170151,
	name = "专属弹幕-马赛曲I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170151	};
	}
};
{
	id = 170152,
	name = "专属弹幕-马赛曲II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170152	};
	}
};
{
	id = 170171,
	name = "专属弹幕-神通METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170171	};
	}
};
{
	id = 170172,
	name = "专属弹幕-神通METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170172	};
	}
};
{
	id = 170201,
	name = "专属弹幕-休斯敦II-I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170201	};
	}
};
{
	id = 170202,
	name = "专属弹幕-休斯敦II-II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170202	};
	}
};
{
	id = 170231,
	name = "专属弹幕-维达号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170231	};
	}
};
{
	id = 170232,
	name = "专属弹幕-维达号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170232	};
	}
};
{
	id = 170241,
	name = "专属弹幕-基洛夫META I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170241	};
	}
};
{
	id = 170242,
	name = "专属弹幕-基洛夫META II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170242	};
	}
};
{
	id = 170411,
	name = "专属弹幕-水星纪念METAI",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170411	};
	}
};
{
	id = 170412,
	name = "专属弹幕-水星纪念METAII",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170412	};
	}
};
{
	id = 170551,
	name = "专属弹幕-那不勒斯I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170551	};
	}
};
{
	id = 170552,
	name = "专属弹幕-那不勒斯II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170552	};
	}
};
{
	id = 170553,
	name = "专属弹幕-那不勒斯鱼雷-特殊副炮联动",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170553	};
	}
};
{
	id = 170554,
	name = "专属弹幕-那不勒斯鱼雷-特殊副炮联动II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170554	};
	}
};
{
	id = 170571,
	name = "构造之理-霞 I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170571	};
	}
};
{
	id = 170572,
	name = "构造之理-霞 II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170572	};
	}
};
{
	id = 170651,
	name = "专属弹幕-z52I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170651	};
	}
};
{
	id = 170652,
	name = "专属弹幕-z52II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170652	};
	}
};
{
	id = 170681,
	name = "全弹发射-伏波I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170681	};
	}
};
{
	id = 170682,
	name = "全弹发射-伏波II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170682	};
	}
};
{
	id = 170691,
	name = "全弹发射-长风I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170691	};
	}
};
{
	id = 170692,
	name = "全弹发射-长风II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170692	};
	}
};
{
	id = 170721,
	name = "专属弹幕-圣塔菲I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170721	};
	}
};
{
	id = 170722,
	name = "专属弹幕-圣塔菲II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170722	};
	}
};
{
	id = 170761,
	name = "逐光之焰-格伦维尔I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170761	};
	}
};
{
	id = 170762,
	name = "逐光之焰-格伦维尔II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170762	};
	}
};
{
	id = 170771,
	name = "专属弹幕-克利奥佩特拉I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170771	};
	}
};
{
	id = 170772,
	name = "专属弹幕-克利奥佩特拉II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170772	};
	}
};
{
	id = 170781,
	name = "专属弹幕-特拉法尔加",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170782	};
		{	tech = 1, rarity = 1, id = 170781	};
	}
};
{
	id = 170791,
	name = "专属弹幕-江风META",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170792	};
		{	tech = 1, rarity = 1, id = 170791	};
	}
};
{
	id = 170801,
	name = "全弹发射-迪凯纳级I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170801	};
	}
};
{
	id = 170802,
	name = "全弹发射-迪凯纳级II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170802	};
	}
};
{
	id = 170861,
	name = "专属弹幕-杜威META",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170862	};
		{	tech = 1, rarity = 1, id = 170861	};
	}
};
{
	id = 170871,
	name = "专属弹幕-冒险号I",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 170871	};
	}
};
{
	id = 170872,
	name = "专属弹幕-冒险号II",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170872	};
	}
};
{
	id = 170881,
	name = "专属弹幕-皇家詹姆斯",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 170882	};
		{	tech = 1, rarity = 1, id = 170881	};
	}
};
{
	id = 180000,
	name = "弗里茨副炮",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 180000	};
	}
};
{
	id = 180001,
	name = "小埃吉尔自带强化型副炮",
	type = 2,
	nationality = 4,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 180001	};
	}
};
{
	id = 594017,
	name = "美系剧情海伦娜主炮",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 594017	};
	}
};
{
	id = 594018,
	name = "美系剧情北卡主炮",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 594018	};
	}
};
{
	id = 594019,
	name = "美系剧情华盛顿主炮",
	type = 4,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 594019	};
	}
};
{
	id = 630011,
	name = "【愚人节活动】紫布里武器",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630011	};
		{	tech = 3, rarity = 4, id = 630012	};
	}
};
{
	id = 630021,
	name = "【愚人节活动2021】金布里自卫火炮",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630021	};
	}
};
{
	id = 630022,
	name = "【愚人节活动2021】金布里特殊弹幕",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630022	};
		{	tech = 3, rarity = 4, id = 630023	};
	}
};
{
	id = 630024,
	name = "【愚人节活动2021】金布里特殊钻头",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630024	};
	}
};
{
	id = 630050,
	name = "【愚人节活动2022】金布里特殊钻头",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630050	};
	}
};
{
	id = 630053,
	name = "【愚人节活动2022】紫布里武器",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630053	};
		{	tech = 3, rarity = 4, id = 630054	};
	}
};
{
	id = 630055,
	name = "【愚人节活动2022】紫布里四联鱼雷",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 630055	};
	}
};
{
	id = 630056,
	name = "【愚人节活动2022】彩布里主炮武器",
	type = 11,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630056	};
	}
};
{
	id = 630057,
	name = "【愚人节活动2022】彩布里特殊弹幕",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630057	};
	}
};
{
	id = 630058,
	name = "【愚人节活动2022】彩布里五联鱼雷",
	type = 5,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 630058	};
	}
};
{
	id = 630059,
	name = "【愚人节活动2022】金布里鱼雷机",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630059	};
	}
};
{
	id = 630060,
	name = "【愚人节活动2022】金布里轰炸机",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630060	};
	}
};
{
	id = 630061,
	name = "【愚人节活动2023】彩布里 锤子主炮",
	type = 11,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630061	};
	}
};
{
	id = 630062,
	name = "【愚人节活动2023】彩布里 兵装效果",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630062	};
	}
};
{
	id = 630071,
	name = "【愚人节活动2024】金布里机甲 钻头导弹",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630071	};
	}
};
{
	id = 630073,
	name = "【愚人节活动2024】金布里机甲 鱼雷触发器",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630073	};
	}
};
{
	id = 630081,
	name = "【愚人节活动2025】彩布里 锤子主炮（正常威力）",
	type = 11,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630081	};
	}
};
{
	id = 630082,
	name = "【愚人节活动2025】彩布里 兵装效果（正常威力）",
	type = 2,
	nationality = 1,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630082	};
	}
};
{
	id = 630221,
	name = "【2022异世界勇者】拉菲-兔兔火球主炮",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 630221	};
	}
};
{
	id = 630222,
	name = "【2022异世界勇者】标枪 普通斩击子弹",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630222	};
	}
};
{
	id = 630223,
	name = "【2022异世界勇者】标枪 消弹蓄力斩击鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630223	};
	}
};
{
	id = 630224,
	name = "【2022异世界勇者】绫波 普通气功波子弹",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630224	};
	}
};
{
	id = 630225,
	name = "【2022异世界勇者】绫波 蓄力气功波鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630225	};
	}
};
{
	id = 630226,
	name = "【2022异世界勇者】Z23 普通近身战斧挥砍",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630226	};
	}
};
{
	id = 630227,
	name = "【2022异世界勇者】Z23 远程战斧鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 630227	};
	}
};
{
	id = 630228,
	name = "【2022异世界勇者】空武器",
	type = 2,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 630228	};
	}
};
{
	id = 650601,
	name = "【2020法系活动剧情用】双联装155mm主炮Mle1920",
	type = 2,
	nationality = 8,
	sub_equips = {
		{	tech = 0, rarity = 3, id = 650601	};
	}
};
{
	id = 650602,
	name = "【2020法系活动剧情用】双联装130mm主炮Mle1935",
	type = 1,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 2, id = 650602	};
	}
};
{
	id = 650603,
	name = "【2020法系活动剧情用】双联550mm鱼雷",
	type = 5,
	nationality = 8,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 650603	};
	}
};
{
	id = 650604,
	name = "【2020法系活动剧情用】四联装380mm主炮Mle1935",
	type = 4,
	nationality = 8,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 650604	};
	}
};
{
	id = 800000,
	name = "【三笠剧情】驱逐武器",
	type = 1,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800000	};
	}
};
{
	id = 800001,
	name = "【三笠剧情】重巡武器",
	type = 3,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800001	};
	}
};
{
	id = 800002,
	name = "【三笠剧情】防空炮",
	type = 6,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800002	};
	}
};
{
	id = 800003,
	name = "【三笠剧情】三联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800003	};
	}
};
{
	id = 800004,
	name = "【三笠剧情】四联鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800004	};
	}
};
{
	id = 800005,
	name = "【三笠剧情】重樱战斗机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800005	};
	}
};
{
	id = 800006,
	name = "【三笠剧情】重樱鱼雷机",
	type = 8,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800006	};
	}
};
{
	id = 800007,
	name = "【三笠剧情】重樱轰炸机",
	type = 9,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800007	};
	}
};
{
	id = 800008,
	name = "【三笠剧情】三笠主炮",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800008	};
	}
};
{
	id = 800009,
	name = "【三笠剧情】比叡主炮",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 800009	};
	}
};
{
	id = 800100,
	name = "【大世界五章剧情用】五联装533mm鱼雷",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 800100	};
	}
};
{
	id = 800101,
	name = "【大世界五章剧情用】五联装533mm鱼雷Mark IX",
	type = 5,
	nationality = 2,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 800101	};
	}
};
{
	id = 800102,
	name = "【大世界五章剧情用】潜艇用G7e声导鱼雷",
	type = 13,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 800102	};
	}
};
{
	id = 820850,
	name = "【2021岛风活动剧情用】双联100mm98式高射炮",
	type = 1,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820850	};
	}
};
{
	id = 820851,
	name = "【2021岛风活动剧情用】203mm连装炮",
	type = 3,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 820851	};
	}
};
{
	id = 820852,
	name = "【2021岛风活动剧情用】双联装203mmSKC主炮",
	type = 3,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820852	};
	}
};
{
	id = 820853,
	name = "【2021岛风活动剧情用】410mm连装炮",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 820853	};
	}
};
{
	id = 820854,
	name = "【2021岛风活动剧情用】四联装610mm鱼雷",
	type = 5,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820854	};
	}
};
{
	id = 820855,
	name = "【2021岛风活动剧情用】四联装533mm磁性鱼雷",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820855	};
	}
};
{
	id = 820856,
	name = "【2021岛风活动剧情用】410mm连装炮（奥丁用高装填）",
	type = 4,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 4, id = 820856	};
	}
};
{
	id = 820857,
	name = "【2021岛风活动剧情用】四联装533mm磁性鱼雷（奥丁用高装填）",
	type = 5,
	nationality = 4,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820857	};
	}
};
{
	id = 820858,
	name = "【2021岛风活动剧情用】零战五二型",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820858	};
	}
};
{
	id = 820859,
	name = "【2021岛风活动剧情用】彗星",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820859	};
	}
};
{
	id = 820860,
	name = "【2021岛风活动剧情用】流星",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 820860	};
	}
};
{
	id = 841050,
	name = "空武器",
	type = 10,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 841050	};
	}
};
{
	id = 841051,
	name = "空武器（鱼雷触发器）",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 841051	};
	}
};
{
	id = 892914,
	name = "【2022公海舰队剧情用】穿甲战列主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 892914	};
	}
};
{
	id = 960001,
	name = "【翻格子活动】驱逐主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960001	};
	}
};
{
	id = 960002,
	name = "【翻格子活动】驱逐三联鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960002	};
	}
};
{
	id = 960003,
	name = "【翻格子活动】驱逐四联磁雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960003	};
	}
};
{
	id = 960004,
	name = "【翻格子活动】驱逐五联鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960004	};
	}
};
{
	id = 960005,
	name = "【翻格子活动】战列双联主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960005	};
	}
};
{
	id = 960006,
	name = "【翻格子活动】战列三联主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960006	};
	}
};
{
	id = 960007,
	name = "【翻格子活动】战列四联主炮（法）",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960007	};
	}
};
{
	id = 960008,
	name = "【翻格子活动】战列四联主炮（英）",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 960008	};
	}
};
{
	id = 960009,
	name = "【翻格子活动】铁血战斗机",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960009	};
	}
};
{
	id = 960010,
	name = "【翻格子活动】铁血轰炸机",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960010	};
	}
};
{
	id = 960011,
	name = "【翻格子活动】重樱战斗机",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960011	};
	}
};
{
	id = 960012,
	name = "【翻格子活动】重樱鱼雷机",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960012	};
	}
};
{
	id = 960013,
	name = "【翻格子活动】重樱轰炸机",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960013	};
	}
};
{
	id = 960014,
	name = "【翻格子活动】白鹰战斗机",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960014	};
	}
};
{
	id = 960015,
	name = "【翻格子活动】白鹰鱼雷机",
	type = 8,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960015	};
	}
};
{
	id = 960016,
	name = "【翻格子活动】白鹰轰炸机",
	type = 9,
	nationality = 1,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960016	};
	}
};
{
	id = 960017,
	name = "【翻格子活动】皇家战斗机",
	type = 7,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960017	};
	}
};
{
	id = 960018,
	name = "【翻格子活动】皇家鱼雷机",
	type = 8,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960018	};
	}
};
{
	id = 960019,
	name = "【翻格子活动】皇家轰炸机",
	type = 9,
	nationality = 2,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960019	};
	}
};
{
	id = 960020,
	name = "【翻格子活动】鸢尾战斗机",
	type = 7,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960020	};
	}
};
{
	id = 960021,
	name = "【翻格子活动】鸢尾鱼雷机",
	type = 8,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960021	};
	}
};
{
	id = 960022,
	name = "【翻格子活动】鸢尾轰炸机",
	type = 9,
	nationality = 3,
	sub_equips = {
		{	tech = 1, rarity = 1, id = 960022	};
	}
};
{
	id = 3139701,
	name = "【2024异世界冒险 剧情】抚顺 主炮弹幕",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139701	};
	}
};
{
	id = 3139702,
	name = "【2024异世界冒险 剧情】抚顺 鱼雷剑气",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139702	};
	}
};
{
	id = 3139703,
	name = "【2024异世界冒险 剧情】利物浦 小天使飞机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139703	};
	}
};
{
	id = 3139706,
	name = "【2024异世界冒险 剧情】独角兽 独角兽飞机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139706	};
	}
};
{
	id = 3139709,
	name = "【2024异世界冒险 剧情】努比亚人 药剂投掷",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139709	};
	}
};
{
	id = 3139710,
	name = "【2024异世界冒险 剧情】鲁莽 主炮火球",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139710	};
	}
};
{
	id = 3139711,
	name = "【2024异世界冒险 剧情】鲁莽 鱼雷陨石",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139711	};
	}
};
{
	id = 3139712,
	name = "【2024异世界冒险 剧情】倔强 主炮冰晶",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139712	};
	}
};
{
	id = 3139713,
	name = "【2024异世界冒险 剧情】倔强 鱼雷冰爆",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139713	};
	}
};
{
	id = 3139716,
	name = "【2024异世界冒险 剧情】阿尔及利亚 主炮弹幕",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139716	};
	}
};
{
	id = 3139717,
	name = "【2024异世界冒险 剧情】阿尔及利亚 鱼雷剑气",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139717	};
	}
};
{
	id = 3139718,
	name = "【2024异世界冒险 剧情】不屈 主炮弹幕",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139718	};
	}
};
{
	id = 3139719,
	name = "【2024异世界冒险 剧情】不屈 鱼雷骑枪",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139719	};
	}
};
{
	id = 3139720,
	name = "【2024异世界冒险 剧情】前卫 金色炮弹",
	type = 4,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139720	};
	}
};
{
	id = 3139722,
	name = "【2024异世界冒险 剧情】圣女贞德 主炮弹幕",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139722	};
	}
};
{
	id = 3139723,
	name = "【2024异世界冒险 剧情】圣女贞德 鱼雷光弹",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139723	};
	}
};
{
	id = 3139724,
	name = "【2024异世界冒险 剧情】霞飞 飞机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139724	};
	}
};
{
	id = 3139728,
	name = "【2024异世界冒险 剧情】腓特烈·卡尔 激光",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3139728	};
	}
};
{
	id = 3165001,
	name = "【2024幼儿园活动 剧情战】小斯佩主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3165001	};
	}
};
{
	id = 3217501,
	name = "【2024风帆二期剧情战】我方后排加农炮",
	type = 4,
	nationality = 96,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3217501	};
	}
};
{
	id = 3227202,
	name = "【2024tolove联动 剧情战】菈菈 重巡主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227202	};
	}
};
{
	id = 3227203,
	name = "【2024tolove联动 剧情战】菈菈 重巡副炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227203	};
	}
};
{
	id = 3227204,
	name = "【2024tolove联动 剧情战】娜娜 驱逐主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227204	};
	}
};
{
	id = 3227205,
	name = "【2024tolove联动 剧情战】娜娜 驱逐鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227205	};
	}
};
{
	id = 3227206,
	name = "【2024tolove联动 剧情战】梦梦 轻巡主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227206	};
	}
};
{
	id = 3227207,
	name = "【2024tolove联动 剧情战】梦梦 轻巡鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227207	};
	}
};
{
	id = 3227208,
	name = "【2024tolove联动 剧情战】金色暗影 战列主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227208	};
	}
};
{
	id = 3227209,
	name = "【2024tolove联动 剧情战】金色暗影 战列副炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227209	};
	}
};
{
	id = 3227210,
	name = "【2024tolove联动 剧情战】春菜 战巡主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227210	};
	}
};
{
	id = 3227211,
	name = "【2024tolove联动 剧情战】春菜 战巡副炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227211	};
	}
};
{
	id = 3227212,
	name = "【2024tolove联动 剧情战】唯 战斗机",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227212	};
	}
};
{
	id = 3227213,
	name = "【2024tolove联动 剧情战】唯 轰炸机",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227213	};
	}
};
{
	id = 3227214,
	name = "【2024tolove联动 剧情战】唯 鱼雷机",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3227214	};
	}
};
{
	id = 3247001,
	name = "【2025拉斐尔活动 剧情战】我方meta战列主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3247001	};
	}
};
{
	id = 3247002,
	name = "【2025拉斐尔活动 剧情战】我方meta重巡主炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3247002	};
	}
};
{
	id = 3247003,
	name = "【2025拉斐尔活动 剧情战】我方meta副炮",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3247003	};
	}
};
{
	id = 3247004,
	name = "【2025拉斐尔活动 剧情战】我方meta鱼雷",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3247004	};
	}
};
{
	id = 3276001,
	name = "【2025狮UR活动 剧情】构建者 主炮弹幕",
	type = 2,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3276001	};
	}
};
{
	id = 3276002,
	name = "【2025狮UR活动 剧情】构建者 鱼雷触手",
	type = 5,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3276002	};
	}
};
{
	id = 3276003,
	name = "【2025狮UR活动 剧情】构建者 舰载机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3276003	};
	}
};
{
	id = 3279401,
	name = "【2025黑岩联动 剧情战】死亡主宰空袭飞机",
	type = 7,
	nationality = 0,
	sub_equips = {
		{	tech = 3, rarity = 5, id = 3279401	};
	}
};
{
	id = 3297001,
	name = "【2025优米雅联动 剧情战】我方优米雅战斗机",
	type = 7,
	nationality = 1,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3297001	};
	}
};
{
	id = 3297002,
	name = "【2025优米雅联动 剧情战】我方优米雅鱼雷机",
	type = 8,
	nationality = 4,
	sub_equips = {
		{	tech = 0, rarity = 5, id = 3297002	};
	}
};
{
	id = 3317601,
	name = "【2025白凤UR活动 剧情战】457主炮（非战列舰种使用的特殊版本）",
	type = 0,
	nationality = 0,
	sub_equips = {
		{	tech = 0, rarity = 0, id = 3317601	};
	}
};
}

p.equip_type = {
	[1] = "舰炮(驱逐)",
	[2] = "舰炮(轻巡)",
	[3] = "舰炮(重巡)",
	[4] = "舰炮(战列)",
	[5] = "鱼雷(水面)",
	[6] = "防空炮(近程)",
	[7] = "战斗机",
	[8] = "鱼雷机",
	[9] = "轰炸机",
	[10] = "设备(通常)",
	[11] = "舰炮(大口径重巡)",
	[12] = "水上机",
	[13] = "鱼雷(潜艇)",
	[14] = "设备(反潜)",
	[15] = "反潜机",
	[17] = "直升机",
	[18] = "货物",
	[20] = "导弹",
	[21] = "防空炮(远程)",
	[101] = "通常特殊兵装",
	[102] = "专属特殊兵装",
}

return p
