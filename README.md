# README #

********************************

- **Author:** Zachary Gover
- **Current Stable Version:** 1.0.2
- **Bitbucket Repository:** [https://bitbucket.org/Zachary1748/agile-life](https://bitbucket.org/Zachary1748/agile-life)
- **Available Features:**
	- Side menu
	- Menu screens
	- Create board screen
	- Home screen
	- Edit Board
	- Board Details
	- Create Story
	- Edit Story
	- Story Details
	- Create Sub-task
	- Subtask Details
	- About
	- Legal
	- Support

### Change log: ###

###04-30-2016:###
--------------------------------
- **What features were worked on?**
	- Story List
	- Edit Board
	- Home Screen
	- Side Menu
	- Static Pages
- **How far along is each feature?**
	- **Story List**
		- Fixed bug that was not updating tableview after editing a board.
	- **Edit Board**
		- Fixed bug that was not updating stories when the user would change a stages name.
	- **Home Screen**
		- Fixed bug that were displaying rows that were not within their current board.
		- Finished implementing the fetching of board/story details.
	- **Side Menu**
		- Implemented functionality to pull boards total completion level.
	- **Legal and About**
		- Design has been completed.
	- **Support**
		- Mail functionality has been implemented.
	- **Donate View**
		- Compeleted Design and implemented donation functionality.
- **Where is the developer struggling?**
	- The developer did not struggle anywhere in specific.
- **Were any change requests submitted?**
	- No change request were submitted.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

###04-28-2016:###
--------------------------------
- **What features were worked on?**
	- Story List
	- Home Screen Story List
- **How far along is each feature?**
	- **Story List**
		- Completed total completion percentage.
	- **Home Screen Story List**
		- Completed functionality of fetching stories and their corresponding details for each board preview.
		- Linked each story to the detail view.
		- Linked table footer to the board detail view
- **Where is the developer struggling?**
	- Calculating total completion from the total amount of subtasks and the total amount of completed subtasks (completed).
- **Were any change requests submitted?**
	- No change request were submitted.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

###04-27-2016:###
--------------------------------
- **What features were worked on?**
	- Create Story
	- Edit Story
	- Edit Subtask
	- Story Detail
- **How far along is each feature?**
	- **Uncategorized**
		- Added delete functionality
	- **Create Story**
		- Defaulted pre-selected stage to the currently selected tab index.
	- **Edit Story**
		- Defaulted pre-selected stage to the stories corresponding stage.
	- **Edit Subtask**
		- Completed design.
		- Implemented functionality to update/complete the subtask
	- **Story Detail**
		- Added subtask completion icon to tableview when subtask has been completed.
- **Where is the developer struggling?**
	- Preselecting the corresponding stage in the pickerview for the current story, when editing (completed).
- **Were any change requests submitted?**
	- No change request were submitted.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

###04-23-2016:###
--------------------------------
- **What features were worked on?**
	- Edit Board
	- Create Story
	- Story Details
	- Edit Story
	- Create Subtask
	- Subtask Details
- **How far along is each feature?**
	- **Edit Board**
		- Created edit board screen and completed design.
		- Implemented functionality to edit the existing board.
	- **Create Story**
		- Started implementing functionality to create a story (About 1hr left).
		- Design has been completed.
	- **Edit Story**
		- Edit story functionality has been implemented
		- Design has been completed
	- **Story Details**
		- Design has been completed
		- funcationlity has been implemented to fetch story details.
	- **Create Subtask**
		- Design has been completed.
		- functionality has been implemented to create the subtask
	- **Subtask Details**
		- Design has been completed.
		- Functionality has been implemented to fetch subtask details.
- **Where is the developer struggling?**
	- Combining both a navigation controller (completed).  
- **Were any change requests submitted?**
	- No change request were submitted.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

###04-19-2016:###
--------------------------------
- **What features were worked on?**
	- Create Board
	- Home Screen
	- Side Menu
	- Story List
- **How far along is each feature?**
	- **Create Board**
		- Implemented CoreData
		- Implemented functionality to create a board.
		- Added user feedback (alerts) when any of the validation is incorrect.
	- **Home Screen**
		- Started listing each board on the home screen.
	- **Side Menu**
		- Started listing each board in the side menu.
		- Linked and passed the currently selected board to the board detail view (StoryListViewController).
	- **Story List**
		- Implemented stages on a UITabBar, based off of what the user configured when they had created the board.
		- Added all four stage screens
- **Where is the developer struggling?**
	- The developer did not struggle anywhere in specific.
- **Were any change requests submitted?**
	- No change request were submitted.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

###04-16-2016:###
--------------------------------
- **What features were worked on?**
	- Side Menu
	- Home Screen
	- Create Board
- **How far along is each feature?**
	- **Uncategorized**
		- Added all necessary view controllers in which are linked from the side menu.
		- Started creating the data model.
	- **Side Menu**
		- Linked the add board button to the add board screen.
	- **Home Screen**
		- Designed home page table view for each board and up to 3 stories per preview.
	- **Create Board**
		- Designed create board screen.
- **Where is the developer struggling?**
	- Linking the add board screen from 2 views behind itself (Completed).
- **Were any change requests submitted?**
	- 1 Change request was submitted to change the selector for each stage.
- **Is the milestone still on pace to be completed on time?**
	- Yes milestone is still on track to be completed.

#### 04-16-2016: ####

- **What features were worked on?**
	- Side Menu
	- Home Screen
	- Create Board
- **How far along is each feature?**
	- **Uncategorized**
		- Added all necessary view controllers in which are linked from the side menu.
		- Started creating the data model.
	- **Side Menu**
		- Linked the add board button to the add board screen.
	- **Home Screen**
		- Designed home page table view for each board and up to 3 stories per preview.
	- **Create Board**
		- Designed create board screen.

#### 04-13-2016: ####

- **What features were worked on?**
	- Launch Screen
	- Side Menu
	- App Icons
- **How far along is each feature?**
	- **Uncategorized**
		- Added all necessary scenes in which are linked from the side menu.
	- **Launch Screen**
		- Launch screen design has been completed.
	- **Side Menu**
		- Custom tableview rows have finished design.
		- *Agile Life* tableview in the side menu has been implemented, while linking to their corresponding view.
		- Completed design for the board list custom table header.
	- **App Icons**
		- App icons have finished being added the application.

		
#### 04-11-2016: ####

- **What features were worked on?**
	- Home Screen
	- Side Menu
- **How far along is each feature?**
	- **Home Screen**
		- Navigation bar colors were set.
		- Side menu button/icon was added
	- **Side Menu**
		- Side menu was added and implemented from a library called `SWRevealViewController`. [GitHub Link](https://github.com/John-Lluch/SWRevealViewController).
		- Header design was implemented.
		- Dummy text was added for the total completion calculation.
		- Added home screen button and linked appropriately.