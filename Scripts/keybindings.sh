data=$(
	cat <<-EOF
		Category        Keybinding                                   Difinition
		# System Keybindings [Super = Enter]
		System super + w                                    Open Browser.
		System super + f                                    File Manager.
		System super + b                                    Open Burpsuite.
		System super + m                                    Mount a Device.
		System super + shift + m                            Open Keybindings Manual.
		System super + shift + b                            Toggle Top bar.
		System super + p                                    Take a Screenshot With Selection.
		System super + equal or minus or backspace          Volume.
		System super + shift + e                            Exit Machine.
		System super + F1 or F2                             Brightness.

		# DWM Keybindings [Super = Enter]
		DWM super + d                                    Run Dmenu.
		DWM super + j                                    Change Focus.
		DWM super + k                                    Change Focus.
		DWM super + Enter                                Open a Terminal.
		DWM super + tab                                  Switch Workspaces.
		DWM super + shift + c                            kill a Window.
		DWM super + shift + b                            Toggle Top Bar.
		DWM super + shift + q                            Kill DWM.
		DWM super + shift + j                            Move a Window Down In Stack.
		DWM super + shift + k                            Move a Window Up In Stack.
		DWM super + shift + l                            Increase Left Window Size In Stack.
		DWM super + shift + h                            Increase Right Window Size In Stack.
		DWM super + shift + Enter                        Move a Terminal To Stack.

		# Tmux [Prefix = Ctrl + b]
		Tmux Prefix + :                                  Enter Command mode.
		Tmux Prefix + |                                  Split Horizontal.
		Tmux Perfix + -                                  Split Vertical.
		Tmux Perfix + r                                  Reload Configurations.
		Tmux Perfix + d                                  Detache current session.
		Tmux Perfix + m                                  Minimize or Maximize.
		Tmux Perfix + I                                  Install Plugins.
		Tmux Perfix + c                                  Create a new window.
		Tmux Perfix + x                                  Kill current pane.
		Tmux Perfix + ,                                  Rename a window.
		Tmux Perfix + w                                  List all window.
		Tmux Perfix + p                                  Previous window.
		Tmux Perfix + n                                  Next window.
		Tmux Perfix + &                                  Close current window.
		Tmux Perfix + h                                  Resize Left and Right.
		Tmux Perfix + j                                  Resize Up nad Down.
		Tmux Perfix + k                                  Resize Up nad Down.
		Tmux Perfix + l                                  Resize Left and Right.
		Tmux Perfix + Ctrl + l                           Clear pane screen.
		Tmux Perfix + [0...9]                            Select window by number.
		Tmux Ctrl + h                                    Change Focus To Left.
		Tmux Ctrl + l                                    Change Focus To Right.
		Tmux Ctrl + j                                    Change Focus To Down.
		Tmux Ctrl + k                                    Change Focus To Up.

		# Terminal [Kitty]
		Kitty super + shift + equal                       Increase Font Size.
		Kitty super + shift + minus                       Decrease Font Size.
		Kitty ctrl  + shift + up                          Scroll up.
		Kitty ctrl  + shift + down                        Scroll down.
		Kitty ctrl  + l                                   Clear Terminal Screen.
		Kitty ctrl  + r                                   Fuzzy find through the shell history.
		Kitty ctrl  + t                                   Fuzzy find all files and subdirectories of the working directory.
		Kitty alt   + c                                   Fuzzy find all subdirectories of the working directory, and cd to output.

		# PDF Viewer [Zathura]
		Zathura Ctrl + r                                  Toggle Theme.

		# Image Viewer [Sxiv]
		Sxiv n                                            Next Image.  
		Sxiv p                                            Previous Image.  
		Sxiv Enter                                        Toggle Mode.

	EOF
)

echo "$data" | sed 's/^[[:space:]]*//' | fzf 
