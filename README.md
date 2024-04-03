

All of the zones does not provide positions in any convertable units but in relative positions for whole map (all coords are relative position from 0 to 1 with decimal precision of 10).
They are somewhat close from wiever perspective but are a bit different for each zone if you aim for percission. As fart as I seen most addons just use some common coeficient for type of zone.
This addon is checking map instead of zone so it calibrates to any map texture you see (pultiple floors, multiple dungeon wings and so on). 
As there is huge amount of maps it is taking long time to calibrate them for any help would be appreciated if you are willing to contribute. 
When showing distance labels in enabled then if they are yellow(ish) that means this map is not calibrated (for zone and subzone defaults are used and are inprecise but close, but all other types of maps just goes off the charts incorrect)


**How to calibrate**

To toggle calibration UI need to run command line:  /mapradar calibrate or /mr calibrate

![image](https://github.com/ecizevskis/eso-map-radar/assets/9670736/40325187-42c2-4aa6-bee0-11ec173b6d29)


For calculation 1 meter value in relative units  some distance is measured in world with some skill and then divided by skill range.
Bow skill **Snipe** with **Focused Aim** morph was chosen (and code is using 40 meter distance in calculations) for this role because its range is 40 meters and it is relatively easy to level up. So once skill is obtained there are to ways of calc:

1. Party duel: This is most strait forward way but obviously require two people, if you are doing calibration then your partner should be party leader (code looks for this pin to read its position).
   You have to find even surface start duel and spread, then pointing on your target with a bow **Focused Aim** skill will become available when you reach 40 meters. Move slowly back and forth (while bracing you move more precise)
   to find a spot where Focused Aim just and press "+" button near "Group Calibration" text. Move camera and pins should regenerate for more precise positions.

2. Solo calibration: If you have no group partner then this way is next what is possible but is more tricky.
  
   In towns you might find some stationary NPCs (guards are good for this) the ones you are allowed to attack by game and so skill icons light up.
   Important: NPC should not move at all!!!
   - Aim for this NPC and move back until **Focused Aim** gets disabled (move slowly back and forth to find that spot where it exactly gets disabled and stays disabled)
   - Press the arrow button near "Solo calibration" label and notification in chat window should appear that position one was saved.
   - Go to this NPC on straight line and just bounce in it, when you are as close to NPC as possible then press "+" button near "Solo calibration" label
  
   In the wild same could be done to any hostile stationary humanoid (humanoids have smaller hitbox so measurements gets more precise)
   - Aim hostile NPC but this time find spot where **Focused Aim** skill will become available
   - Press the arrow button near "Solo calibration" label and notification in chat window should appear that position one was saved.
   - Now need to kill this NPC and make sure it does not move and stand on exact place where it was standing. (I use stampede 2H skill to jump on target and trying remember where exactly it is standing, because when they fall they are not centered on place where they were standing)
