extends Node


func activate():
	Settings.curses.append(PlayerStats.save_id)
	Settings.save_settings()
	Game.remove_cursed_files()
	Game.exit_game()
