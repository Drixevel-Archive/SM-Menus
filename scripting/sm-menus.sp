#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

enum struct Menus
{
	char command[32];
	char flags[32];
	char title[32];
	char action[32];
	char value[32];
	char type[32];
	char text[32];
	bool maintain;
	int index;
}

//Menus g_Menus[256][256];

public Plugin myinfo = 
{
	name = "[SM] Menus", 
	author = "Drixevel", 
	description = "An easy utility to create and maintain custom menus using configuration files.", 
	version = "1.0.0", 
	url = "https://drixevel.dev/"
};

public void OnPluginStart()
{
	ParseMenuConfigs();
}

void ParseMenuConfigs()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "configs/menus/");

	Format(sPath, sizeof(sPath), "%stest.cfg", sPath);
	ParseConfig(sPath);
}

void ParseConfig(const char[] path)
{
	PrintToServer(path);
	KeyValues kv = new KeyValues("menu");

	if (!kv.ImportFromFile(path) || !kv.GotoFirstSubKey(false))
		return;
	
	BrowseKeyValues(kv);

	delete kv;
}

void BrowseKeyValues(KeyValues kv)
{
	do
	{
		// You can read the section/key name by using kv.GetSectionName here.

		char sSection[32];
		kv.GetSectionName(sSection, sizeof(sSection));
		PrintToServer("Section: %s", sSection);

		if (kv.GotoFirstSubKey(false))
		{
			// Current key is a section. Browse it recursively.
			BrowseKeyValues(kv);
			kv.GoBack();
		}
		else
		{
			// Current key is a regular key, or an empty section.
			if (kv.GetDataType(NULL_STRING) != KvData_None)
			{
				// Read value of key here (use NULL_STRING as key name). You can
				// also get the key name by using kv.GetSectionName here.
			}
			else
			{
				// Found an empty sub section. It can be handled here if necessary.
			}
		}
	} while (kv.GotoNextKey(false));
}