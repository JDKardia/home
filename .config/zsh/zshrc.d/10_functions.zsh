frg() {
	INITIAL_QUERY=""
	RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
	FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'"
	fzf --bind "change:reload:$RG_PREFIX {q} || true" \
		--ansi --query "$INITIAL_QUERY" \
		--height=50% --layout=reverse "$@"
}

lsgh() {
	ls -p | grep / | xargs -I {} sh -c 'echo "{}:\t$(cat {}.git/HEAD)"' | column -t
}

[[ "$(command -v apt)" ]] && sapt() {
		local rg_search_string=$(
			local IFS='|'
			echo "$*"
		)
		apt search "$@" | rg "$rg_search_string" --context 1
}

[[ "$(command -v sql-formatter)" ]] && sqlf() {
	sed -E 's/(@|#|\$)/FUCK\1FUCK/g' |
		sql-formatter -u |
		sed -zE '
    s/ - > / -> /g;
    s/ \| \| / || /g;
    s/ \! = / \!= /g;
    s/ -> > / ->> /g;
    s/:: /::/g;
    s/FUCK(.)FUCK/\1/g;
    s/FUCK (.) FUCK/\1/g;
    s/(\n\s*)(DISTINCT) / \2\1/g;
    s/ WITH UR/\nWITH UR/g'
}
