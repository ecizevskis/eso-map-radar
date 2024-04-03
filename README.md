**About distance calculation**

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

**Checking calibration**

For smaller maps like Delves, crypts, dungeons etc it is not so much important to have it extra precise because zone is quite small.
For main zone maps and subzone maps calibration needs to be checked after calibrating zones and subzones that those values are in accepted error range. 
- Go near town go in and out of subzone
- Find common pin that exists in both maps (usually wayshrines and world bosses)
- Move slowly in/out subzone and check distance and how much it is changing when you enter/exit subzone (sometimes you can get close to point where subzone usually switches and open and close map may trigger zone chanage - easier to spot distance differences)
- Distance diffecences shoul be lower than 1% for seamless transition from zone to subzone distances.
- If it is bigger then need to ckeck other subzone and terermine is some measured imprecise or subzone and recalibrate

**What places to calibrate**

Plan is to calibrate all possible maps (caves, crypts, mansion and so on) so anywhere you see distance is not calibrated (yellow(ish) distance labels) then this place should be measured. If there is no way of doing that as mentioned before, then can just mention this place and how to get to it in Issues. For referencing places English would be desired or finding it on https://gamemap.uesp.net/eso/ and posting link to map or wiki would be very helpful.


**Sending calibration data**

On Windows PC ESO addon data is stored in "%userprofile%\Documents\Elder Scrolls Online\live\SavedVariables", you can find MapRadar.lua there and post its content in **Issues** section of this repository


**Calibration data analysis **

I will try to combine all received data to some google sheet and calculate results from there, so more measurmenets from different people the better and less need for checking each zone to validate.



**Outro**

If you would help on calibrating the world that would be huuuge help and make this addon functional much faster 
