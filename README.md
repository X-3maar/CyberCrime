# CyberCrime
A 2d game made for CyberCrime competition (by Hack Club STEM Egypt)
Game Idea: The servers of the school got hacked, to know the impostor behind this crime, the player should finish the game and crack all the laptops.
The player starts in a classroom finding 5 laptops arranged in the classroom, each laptop belongs to a member in the HCSE high board. He tries to crack the laptops by solving CP problems and CTFs. After cracking all of them he gets the 6 secrect words to submit them in the competition website.

Controls are simple, just use WASD or arrows for movement.

<img width="1115" height="622" alt="image" src="https://github.com/user-attachments/assets/0aa75ce4-9bcb-4a1e-a20f-61adf662848e" />

This game was made as a user interface for the competition where users answer several problems and capture flags in other websites to get the key that cracks each computer.

The engine used to make this project was godot. Its logic was kinda simple just used a ren'py dialaogue plugin to create the dialogues, coded the player movement and animations, and added an invisible scripted collider infront of each computer that activated the dialogue and takes the input password. 

*Note* : The overlapping dialogue bug is kinda unsolvable so make sure to press next before going to another computer.
