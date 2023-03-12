local assets = {
    Asset("ANIM", "anim/klee.zip"),
	Asset("ANIM", "anim/ghost_klee_build.zip"),
}

return CreatePrefabSkin("klee_none", {
	base_prefab = "klee",
	type = "base",
	assets = assets,
	skins = {normal_skin = "klee", ghost_skin = "ghost_klee_build"},
	skin_tags = {"KLEE", "CHARACTER", "BASE"},
	build_name_override = "klee",
	rarity = "Character",
})