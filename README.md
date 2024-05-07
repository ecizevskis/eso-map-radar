## About distance calculation

All of the zones does not provide positions in any convertable units but in relative positions for whole map (all coords are relative position from 0 to 1 with decimal precision of 10).
They are somewhat close from wiever perspective but are a bit different for each zone if you aim for percission. As fart as I seen most addons just use some common coefficient for type of zone.
This addon is checking map instead of zone so it calibrates to any map texture you see (multiple zone levels/floors, multiple dungeon wings and so on). 
As there is huge amount of maps it is taking long time to calibrate them for any help would be appreciated if you are willing to contribute. 
When showing distance labels in enabled then if they are yellow(ish) that means this map is not calibrated (for zone and subzone defaults are used and are inprecise but close, but all other types of maps just goes off the charts incorrect)


## How to calibrate

To toggle calibration UI need to run command line:  /mapradar calibrate or /mr calibrate. Following form should appear on left side of screen.
![image](https://github.com/ecizevskis/eso-map-radar/assets/9670736/d1ca62ef-6632-411f-8079-e7989f570f62)

"Mark position" button saves your curent player position for later use.
"Save calibration" have two configurable ranges that could be set to ranges you want to use and "Save" buttons at the end that would calculate marked position and current position differences and save calibration.

For calculation 1 meter value in relative units some distance is measured in world with some skill and then divided by skill range.
Bow skill **Snipe** with **Focused Aim** morph is suggested for this role because its range is 40 meters and it is relatively easy to level up. 

## Long range calibration
(this is advised in bigger maps for better precission)
   - Aim for this NPC and move back until **Focused Aim** gets disabled (move slowly back and forth to find that spot where it exactly gets disabled and stays disabled)
   - Press the arrow button near "Mark position" label and notification in chat window should appear that position one was saved.
   - Go to this NPC or Hostile on straight line and just bounce in it, when you are as close to NPC as possible then press "Save" button near chosen range (It is advides to use humanoid targets for precission)

   In towns you might find some stationary NPCs (guards are good for this) the ones you are allowed to attack by game and so skill icons light up.
   Important: NPC should not move at all!!!

## Short range calibration

For smaller maps like Delves, crypts, dungeons etc it is not so much important to have it extra precise because zone is quite small. 
Sometimes there is no way to use Bow skill (No one is around or no straight lines long range)
For that secondary calibration range might be used for you area skill of choice. I have chosen templar skill "Cleansing Ritual" with area of 12 meters with self cast.
Skill of choice should have clear area visual where you can clearly see the range of it.
You could check in some bigger already calibrated map where is more precise where is real range: Find some wayshrine where you can position yourself to distance "0" or "0.1" and cast your area skill of choice and them move to edge to see where you stand when getting distance label show skill range.

Example:

![image](https://github.com/ecizevskis/eso-map-radar/assets/9670736/5f030f63-d437-4f1b-bc76-d0bc954c8305)
![image](https://github.com/ecizevskis/eso-map-radar/assets/9670736/5dc97a7b-ff2f-4a35-a1f8-eb6bfbb07073)

In this templar "Cleansing Ritual" skill can see that there is denser greeen color where the front leg is. So on calibrating tight spaces with this area skill try to step on the edge same way


To calibrate some small map just find any even surface and press "Mark position", cast your area skill centered on you and move to the outer edge of area effect and press "Save" near your short range section


## What places to calibrate

Plan is to calibrate all possible maps (caves, crypts, mansion and so on) so anywhere you see distance is not calibrated (yellow(ish) distance labels) then this place should be measured. If there is no way of doing that as mentioned before, then can just mention this place and how to get to it in Issues. For referencing places English would be desired or finding it on https://gamemap.uesp.net/eso/ and posting link to map or wiki would be very helpful.


## Sending calibration data

On Windows PC ESO addon data is stored in "%userprofile%\Documents\Elder Scrolls Online\live\SavedVariables", you can find MapRadar.lua there and post its content in **Issues** section of this repository


## Calibration data analysis

I will try to combine all received data to some google sheet and calculate results from there, so more measurmenets from different people the better and less need for checking each zone to validate.


## Outro

If you would help on calibrating the world that would be huuuge help and make this addon functional much faster 
