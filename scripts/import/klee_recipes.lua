-- 照抄雷电将军的示例
local Recipes = {

    ---------------------------武器-----------------------------
	{
        name = "dococotales",
        ingredients = 
        {
			Ingredient("nightmarefuel", 2),
            Ingredient("papyrus", 6),
            Ingredient("redgem", 4)
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/dococotales.xml",
        image = "dococotales.tex",
        filters = { "WEAPONS", "CHARACTER" },
    },
    -- 贵一点好
    {
        name = "fragments_of_innocence",
        ingredients = 
        {
			Ingredient("papyrus", 5),
            Ingredient("feather_canary", 1),
            Ingredient("featherpencil", 1),
            Ingredient("redgem", 1)
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/dococo_refinement.xml",
        image = "dococo_refinement.tex",
        filters = { "WEAPONS", "CHARACTER" },
    },

    ---------------------------精炼-----------------------------
    --命之座
    {
        name = "klee_constellation_star",
        ingredients = 
        {
			Ingredient("opalpreciousgem", 1),
            Ingredient("redgem", 2),
            Ingredient("red_cap", 10)
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/klee_stella.xml",
        image = "klee_stella.tex",
        filters = { "REFINE", "CHARACTER" },
    },
}


for k, data in pairs(Recipes) do
    AddRecipe2(data.name, data.ingredients, data.level, {
        min_spacing = data.min_spacing,
        nounlock = data.nounlock,
        numtogive = data.numtogive,
        builder_tag = data.builder_tag,
        atlas = data.atlas,
        image = data.image,
        testfn = data.testfn,
        product = data.product,
        build_mode = data.build_mode,
        build_distance = data.build_distance,

        placer = data.placer,
        filter = data.filter,
        description = data.description,
        canbuild = data.canbuild,
        sg_state = data.sg_state,
        no_deconstruction = data.no_deconstruction,
        require_special_event = data.require_special_event,
        dropitem = data.dropitem,
        actionstr = data.actionstr,
        manufactured = data.manufactured,
    }, data.filters)
end