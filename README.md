# NVIDIA Broadcast Stream Deck Scripts
AutoHotkey scripts to control NVIDIA Broadcast filters from a Stream Deck or any launcher that can open .ahk files.

## Setup
1. Make sure you have [AutoHotkey v2.0](https://www.autohotkey.com/) installed.
2. Download this repository as a .zip by pressing the green **Code** button at the top, followed by Download ZIP. Extract the .zip where you want to store the scripts.
3. Choose whether you want to have status-synced buttons, or generic toggle buttons.

### Status-Synced Buttons (recommended)
These buttons will make sure that the status on your Stream Deck stays in sync with NVIDIA Broadcast: if you manually change a filter's status through the NVIDIA Broadcast app, you can assure that when you press a Stream Deck button to update filter status, what's displayed is what the currently active status is.
1. In the Stream Deck app, drag a `Multi Action Switch` into a slot.
2. Under state `1`, add a `System: Open` action and point it to a `...TurnOnEffects.ahk` file.  
(Choose a pair of scripts corresponding to what filter you want to toggle.)
3. Switch to state `2` at the top left, add another `System: Open` action and point it to a `...TurnOffEffects.ahk` file.

Now, the button itself will show if the effect is on or off when you press it. Be sure to give it a test press at least once so the status is synced.

### Generic Toggle Buttons (not recommended)
These buttons will NOT show the status of the filters in NVIDIA Broadcast, and will just merely toggle filters on or off.
1. In the Stream Deck app, drag a `System: Open` action into a slot.
2. Point it to a `...ToggleEffects.ahk` file corresponding to what filter you want to toggle.