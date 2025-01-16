MuffinStuff = LibStub("AceAddon-3.0"):NewAddon("MuffinStuff", "AceConsole-3.0")

-- Define local default values
local defaults = {
	profile = {
		stanceHiddenValue = true,
		combatTextSizeValue = 2.0,
	},
}


-- Define the options table
local options = {
  name = "MuffinStuff Options",
  handler = MuffinStuff,
  type = "group",
  order = 1,
  args = {
      hide_stance_group = {
      type = "group",
      order = 2,
      inline = true,
      name = "Hide Stance/Stealth/Form Bar",
      args = {
        hideStanceToggle = {
          name = "Hide Stance Bar",
          desc = "Toggle hiding the stance bar. Changing this will reload your UI.",
          type = "toggle",
          set = function(info,val) MuffinStuff.db.profile.stanceHiddenValue = val; ReloadUI(); end,
          get = function(info) return MuffinStuff.db.profile.stanceHiddenValue end
        }
      }
    },
    combat_text_size_group = {
      type = "group",
      order = 3,
      inline = true,
      name = "Combat Text Size",
      args = {
        combatTextSizeSlider = {
          name = "Combat Text Size",
          desc = "1 is the default Blizzard setting. Set this to 2 like Papa Simon intended.",
          type = "range",
          min = 1,
          max = 5,
          step = 0.1,
          set = function(info,val) MuffinStuff:SetCombatTextValue(val) end,
          get = function(info) return MuffinStuff.GetCombatTextValue() end
        }
      }
    }
  }
}

-- Called when the addon is loaded
function MuffinStuff:OnInitialize()
  -- Initialize profile DB
  self.db = LibStub("AceDB-3.0"):New("MuffinStuffDB", defaults)
  
  -- Initialize options panel
  LibStub("AceConfig-3.0"):RegisterOptionsTable("MuffinStuff_options", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MuffinStuff_options", "MuffinStuff")

  -- Set the state of the stance bar based on user selection
  if self.db.profile.stanceHiddenValue == true then
    RegisterStateDriver(StanceBarFrame, "visibility", "hide")
  else
    RegisterStateDriver(StanceBarFrame, "visibility", "show")
  end
  
  -- Set combat text to the user selected size
  C_CVar.SetCVar("WorldTextScale", self.db.profile.combatTextSizeValue)
end

-- Setter for Combat Text Value
function MuffinStuff:SetCombatTextValue(val)
  self.db.profile.combatTextSizeValue = val
  C_CVar.SetCVar("WorldTextScale", val)
end

-- Getter for Combat Text Value
function MuffinStuff.GetCombatTextValue()
  return MuffinStuff.db.profile.combatTextSizeValue
end