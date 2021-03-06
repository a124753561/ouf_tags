if not oUF then return end
oUF.debug = {}

local _,playerClass = UnitClass("player")

local numberize = function(val)
    if(val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    elseif (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    else
        return val
    end
end

function round(num, idp)
    if idp and idp>0 then
        local mult = 10^idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end


--===========================--
function NeedsIndicators(unit)
    return ( not UnitIsGhost(unit) or not UnitIsDead(unit) or UnitIsConnected(unit))
end
--===========================--


oUF.Tags["[missinghp]"] = function(u) m=UnitHealthMax(u) - UnitHealth(u); return m>0 and m.. " | " or "" end
oUF.TagEvents["[missinghp]"] = "UNIT_HEALTH UNIT_MAXHEALTH"
oUF.Tags["[missingpp]"] = function(u) m=UnitPowerMax(u) - UnitPower(u); return m>0 and m.. " | " or "" end
oUF.TagEvents["[missingpp]"] = "UNIT_HEALTH UNIT_MAXHEALTH"


oUF.Tags["[shortName]"] = function(u)
return string.sub(UnitName(u),1,4) or ''
end
oUF.TagEvents["[shortName]"] = "UNIT_NAME_UPDATE"

oUF.Tags["[name]"] = function(u)
    if not UnitIsConnected(u) then
        o = "D/C"
    elseif UnitIsAFK(u) then
        o = "AFK"
    elseif UnitIsGhost(u) then
        o = "GHOST"
    elseif UnitIsDead(u) then
        o = "DEAD"
    else 
        o = UnitName(u)
    end
    return o
end
oUF.TagEvents["[name]"] = "UNIT_NAME_UPDATE PLAYER_FLAGS_CHANGED"

oUF.Tags["[raidhp]"] = function(u)
    o = ""
    if not(u == nil) then
        local c, m, n= UnitHealth(u), UnitHealthMax(u), UnitName(u)
        if UnitIsDead(u) then
            o = "DEAD"
        elseif not UnitIsConnected(u) then
            o = "D/C"
        elseif UnitIsAFK(u) then
            o = "AFK"
        elseif UnitIsGhost(u) then
            o = "GHOST"
        elseif(c >= m) then
            o = n:utf8sub(1,4)
        elseif(UnitCanAttack("player", u)) then
            o = math.floor(c/m*100+0.5).."%"
        else
            o = "-"..numberize(m - c)
        end
    end
    return o
end
oUF.TagEvents["[raidhp]"] = "UNIT_HEALTH UNIT_MAXHEALTH PLAYER_FLAGS_CHANGED"

----------
-- TAGS --
----------

oUF.Tags["[targethp]"] = function(u)
	o = ""
	if not(u == nil) then
		local c, m = UnitHealth(u), UnitHealthMax(u)
		local hpp = math.floor(c/m*100+0.5).."%"
		local ms = m-c
		if UnitIsGhost(u) then
			o = "Ghost"
		elseif(UnitIsDead(u)) then 
			o = "DEAD" 
		elseif not UnitIsConnected(u) then
			o = "D/C" 
		elseif(c == m)then
			o = numberize(c)
		else
			o = (ms > 0 and numberize(ms) .. " | " or "") ..hpp
		end
	end
	return o
end
oUF.TagEvents["[targethp]"] = "UNIT_HEALTH UNIT_MAXHEALTH"
	

oUF.Tags["[twilighttorment]"] = function(u) if not NeedsIndicators(u)then return end; local c = select(4, UnitAura(u, "Twilight Torment")); return c and "|cffFF00FFTT|r" or "" end
oUF.TagEvents["[twilighttorment]"] = "UNIT_AURA"
oUF.Tags["[hymnofhope]"] = function(u) if not NeedsIndicators(u)then return end; local c = UnitAura(u, "Hymn of Hope"); return c and "|cff6AB8EC'|r" or "" end
oUF.TagEvents["[hymnofhope]"] = "UNIT_AURA"


oUF.Tags["[pom]"] = function(u)
	if not NeedsIndicators(u)then return end;
	local _,_,_,c = UnitAura(u, "Prayer of Mending");
	return (c and "|cff"..oUF.indicators.buffs['PoM'][c].."·|r" or "");
end
oUF.TagEvents["[pom]"] = "UNIT_AURA"

oUF.Tags["[grace]"] = function(u)
	if not NeedsIndicators(u)then return end; 
	local _,_,_,c = UnitAura(u, "Grace");
	local indicator = "" 
	if c then 
		indicator = "|cff" .. oUF.indicators.buffs['Grace'][c]
		for i = 1,c do indicator = indicator .. "·" end
		indicator = indicator .. "|r"
	end
	return indicator
end
oUF.TagEvents["[grace]"] = "UNIT_AURA"

oUF.Tags["[inspiration]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Inspiration") and "|cffCCCCCC·|r" or "" end
oUF.TagEvents["[inspiration]"] = "UNIT_AURA"

oUF.Tags["[painsupress]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Pain Suppression") and "|cff33FF33+|r" or "" end
oUF.TagEvents["[painsupress]"] = "UNIT_AURA"

oUF.Tags["[powerinfusion]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Power Infusion") and "|cff33FF33+|r" or "" end
oUF.TagEvents["[powerinfusion]"] = "UNIT_AURA"

oUF.Tags["[guardspirit]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Guardian Spirit") and "|cff33FF33+|r" or "" end
oUF.TagEvents["[guardspirit]"] = "UNIT_AURA"

oUF.Tags["[gotn]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Gift of the Naaru") and "|cff0099FF·|r" or "" end
oUF.TagEvents["[gotn]"] = "UNIT_AURA"

oUF.Tags["[rnw]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Renew") and "|cff33FF33·|r" or "" end
oUF.TagEvents["[rnw]"] = "UNIT_AURA"

oUF.Tags["[aegis]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Divine Aegis") and "|cffff0000·|r" or "" end
oUF.TagEvents["[aegis]"] = "UNIT_AURA"

oUF.Tags["[pws]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Power Word: Shield") and "|cffFFFFFF·|r" or "" end
oUF.TagEvents["[pws]"] = "UNIT_AURA"

oUF.Tags["[ws]"] = function(u) if not NeedsIndicators(u)then return end; return UnitDebuff(u, "Weakened Soul") and "|cff33FF33·|r" or "" end
oUF.TagEvents["[ws]"] = "UNIT_AURA"

oUF.Tags["[shad]"] = function(u) if not NeedsIndicators(u)then return end; return (UnitAura(u, "Prayer of Shadow Protection") or UnitAura(u, "Shadow Protection")) and "" or "|cff9900FF·|r" end
oUF.TagEvents["[shad]"] = "UNIT_AURA"

oUF.Tags["[fort]"] = function(u) if not NeedsIndicators(u)then return end; return (UnitAura(u, "Prayer of Fortitude") or UnitAura(u, "Power Word: Fortitude")) and "" or "|cff00A1DE·|r" end
oUF.TagEvents["[fort]"] = "UNIT_AURA"

oUF.Tags["[spirit]"] = function(u) if not NeedsIndicators(u)then return end; return (UnitAura(u, "Prayer of Spirit") or UnitAura(u, "Divine Spirit")) and "" or "|cff2F6373·|r" end
oUF.TagEvents["[spirit]"] = "UNIT_AURA"

oUF.Tags["[fear]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Fear Ward") and "|cffCA21FF'|r" or "" end
oUF.TagEvents["[fear]"] = "UNIT_AURA"

oUF.Tags["[lb]"] = function(u) if not NeedsIndicators(u)then return end; local c = select(4, UnitAura(u, "Lifebloom")) return c and "|cff"..oUF.indicators.buffs['Lifebloom'][c].."·|r" or "" end
oUF.TagEvents["[lb]"] = "UNIT_AURA"

oUF.Tags["[rejuv]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Rejuvenation") and "|cff00FEBF·|r" or "" end
oUF.TagEvents["[rejuv]"] = "UNIT_AURA"

oUF.Tags["[regrow]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Regrowth") and "|cff00FF10·|r" or "" end
oUF.TagEvents["[regrow]"] = "UNIT_AURA"

oUF.Tags["[flour]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Flourish") and "|cff33FF33·|r" or "" end
oUF.TagEvents["[flour]"] = "UNIT_AURA"

oUF.Tags["[tree]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Tree of Life") and "|cff33FF33·|r" or "" end
oUF.TagEvents["[tree]"] = "UNIT_AURA"

oUF.Tags["[gotw]"] = function(u) if not NeedsIndicators(u)then return end; return UnitAura(u, "Gift of the Wild") and "|cff33FF33·|r" or "" end
oUF.TagEvents["[gotw]"] = "UNIT_AURA"

oUF.Tags['[raidtargeticon]'] = function(u) if(not UnitExists(u)) then return '' end local i = GetRaidTargetIndex(u..'target'); return i and ICON_LIST[i]..'22|t' or '' end
oUF.TagEvents['[raidtargeticon]'] = 'UNIT_TARGET RAID_TARGET_UPDATE'

oUF.Tags['[raidtargetname]'] = function(u) if(not UnitExists(u)) then return '' end return UnitName(u..'target') and '- '..UnitName(u..'target') or '' end
oUF.TagEvents['[raidtargetname]'] = 'UNIT_TARGET UNIT_NAME_UPDATE'


	
--++++++++++++++++++++++++++--
--         BUFFS
--++++++++++++++++++++++++++--

oUF.indicators={
	buffs = {
	    ["Grace"] = {"1A7AAF","6AB8EC","ffffff"},
		["PoM"] = {"528EFF","43F3C6","45E836","8ADD2A","D0D21F","C69F15"},
		["Lifebloom"] = {"A7FD0A","6AB8EC","ffffff"},
		
	}, 
	fonts = {
		["DEFAULT"] = {
			offsets = {x = 0, y = 0},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "CENTER",
		},
		["TOPLEFT"] = {
			offsets = {x = 0, y = 3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "LEFT",
		},
		["TOP"] = {
			offsets = {x = 0, y = 3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "CENTER",
		},
		["TOPRIGHT"] = {
			offsets = {x = 3, y = 3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "RIGHT",
		},
		["LEFT"] = {
			offsets = {x = 0, y = 0},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "LEFT",
		},
		["CENTER"] = {
			offsets = {x = 0, y = 0},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "CENTER",
		},
		["RIGHT"] = {
			offsets = {x = 3, y = 0},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "RIGHT",
		},
		["BOTTOMLEFT"] = {
			offsets = {x = 0, y = -3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "LEFT",
		},
		["BOTTOM"] = {
			offsets = {x = 0, y = -3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "CENTER",
		},
		["BOTTOMRIGHT"] = {
			offsets = {x = 3, y = -3},
			size = 8.5,
			name = "Interface\\Addons\\oUF_Tags\\media\\visitor.ttf",
			outline = "OUTLINE",
			alignH = "RIGHT",
		},
	},
	class = {
		DEATHKNIGHT = {
			["TOP"] = "",
			["TOPLEFT"] = "[tree]",
			["TOPRIGHT"] = "[gotw]",
			["BOTTOMLEFT"] = "[lb]",
			["BOTTOMRIGHT"] = "[rejuv][regrow][flour]"
		},
		DRUID = {
			["TOP"] = "",
			["TOPLEFT"] = "[tree]",
			["TOPRIGHT"] = "[gotw]",
			["BOTTOMLEFT"] = "[lb]",
			["BOTTOMRIGHT"] = "[rejuv][regrow][flour]"
		},
		PRIEST = {
			["TOP"] = "[painsupress][powerinfusion][guardspirit][twilighttorment]",
			["TOPLEFT"] = "[pws][ws][aegis]",
			["TOPRIGHT"] = "[spirit][shad][fort][fear]",
			["BOTTOMLEFT"] = "[inspiration][grace][pom]",
			["BOTTOMRIGHT"] = "[rnw][gotn][rejuv][regrow][flour]"
		},
		PALADIN = {
			["TOP"] = "",
			["TOPLEFT"] = "",
			["TOPRIGHT"] = "",
			["BOTTOMLEFT"] = "",
			["BOTTOMRIGHT"] = ""
		},
		SHAMAN = {
			["TOP"] = "",
			["TOPLEFT"] = "",
			["TOPRIGHT"] = "",
			["BOTTOMLEFT"] = "",
			["BOTTOMRIGHT"] = ""
		},
		WARLOCK = {
			["TOP"] = "",
			["TOPLEFT"] = "",
			["TOPRIGHT"] = "",
			["BOTTOMLEFT"] = "",
			["BOTTOMRIGHT"] = ""
		},
		MAGE = {
			["TOP"] = "",
			["TOPLEFT"] = "",
			["TOPRIGHT"] = "",
			["BOTTOMLEFT"] = "",
			["BOTTOMRIGHT"] = ""
		},
		ROGUE = {
			["TOP"] = "",
			["TOPLEFT"] = "",
			["TOPRIGHT"] = "",
			["BOTTOMLEFT"] = "",
			["BOTTOMRIGHT"] = ""
		}
	}
}

function createIndicatorGroup(object,anchor,objectAnchor,fontDB, tags)
    group = objectAnchor:CreateFontString(nil, "OVERLAY")
    group:SetFont(fontDB.name, fontDB.size, fontDB.outline)
    group:SetPoint(anchor, objectAnchor, anchor, fontDB.offsets.x, fontDB.offsets.y)
    group:SetJustifyH(fontDB.alignH)
    object:Tag(group,tags)
    group:Show()
    return group
end


function generateAuraGroups(object)
    if not object.AuraIndicator then return end
    object.FontObjects = object.FontObjects or {}
    
    for index,tags in pairs(oUF.indicators.class[playerClass])do
        local auraGroup = createIndicatorGroup(object, index, object.Health, oUF.indicators.fonts[index], tags)
        object.FontObjects[index] = {
        	name = "Aura Indicator Group : ".. index,
        	object = auraGroup
        }
    end
end

 
for index, object in ipairs(oUF.objects) do  generateAuraGroups(object) end


oUF:RegisterInitCallback(generateAuraGroups)
