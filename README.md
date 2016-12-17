# MemeMe-1.0
###iOS Developer Nanodegree Project

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends.

##Meme Editor View

The Meme Editor View consists of an image view overlaid by two text fields, one near the top and one near the bottom of the image. This view has a bottom toolbar with two buttons: one for the camera and one for the photo album. The top navigation bar has a share button on the left displaying Apple’s stock share icon and a “Cancel” button on the right.

##Meme Detail View

The Meme Detail View displays the selected meme in an image view in the center of the page with the meme’s original aspect ratio. The detail view has a back arrow in the top left corner. To the right of the arrow reads the title of the previous view, “Sent Memes.”

##User Flow

When the user first launches the app the Meme Editor View will appear. In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.

After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.

When the user presses the “Cancel” button, the Meme Editor View returns to its launch state, displaying no image and default text.

When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme. After an option is chosen, the Activity View is dismissed and the Meme Editor View is visible again. 

##Extra Credits

- Embedded Scroll View in Meme Editor View so that user can Zoom In & Zoom Out making is more interactable for the User.
- Pop Animation on the two  Caption Text Views on Orientation Change.
- Ability to choose between number of font styles Apple provides.

##Requirements

 - Xcode 8.0 or above
 - Swift 3 or above
