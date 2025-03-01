return {
	"tpope/vim-eunuch",
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		require("luasnip.loaders.from_snipmate").load(),
	},
}
