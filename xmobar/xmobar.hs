
Config { bgColor = "black"
		, fgColor = "grey"
		, position TopW L 90
		, commands =	[ Run Cpu ["-L", "3", "-H", "50", "--normal", "green", "--high", "red"]
						, Run Memory ["-t", "Mem: <usedratio>%"] 10
						, Run Swap [] 10
						, Run Date "%a %b %_d %l:%M" "date" 10
						, Run StdinReader
						]
		, sepChar = "%"
		, alignSep = "}{"
		, template = "%StdinReader% }{ %cpu% | %memory% * %swap%   <fc=#ee9a00>%date%</fc> | %EGPF%"
		}
