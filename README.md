# Academic Journal Builder📕 &nbsp; [![credits](http://img.shields.io/badge/Academic%20Journal-Builder-purple?labelColor=orange&style=for-the-badge)](https://github.com/Vaccarini-Lorenzo/Academic-Journal-Builder)

### This simple command line tool allows to automate the whole process of grade journaling, managing a Github repository to store and document your academic journey.

![introGif](content/introGif.gif)

# What do you need
- #### A github repository to store your Academic Journal
- #### A valid SSH key for your GitHub account

# Installation

### In order to install the Academic Journal Builder, just clone the repository and execute the install.sh file.
<center>

`cd <path_to_cloned_repo> && ./install.sh`

</center>

# Usage

### 1. Enter your repository link and matricola through the flags `--repo` and `--code`

![addRepoAndMatricola](content/addRepoAndMatricola.gif)

### 2. [Optional] Add you course of study using the flag `--course-of-study`

![courseOfStudy](content/courseOfStudy.gif)

### 3. That's it! Just add your first grade. You can either:
#### &nbsp;&nbsp;&nbsp;&nbsp; 3.1 Add only the grade specifying the numeric value of the grade and the course name with the flags `--name` and `--grade`
![courseOfStudy](content/courseOfStudy.gif)
#### &nbsp;&nbsp;&nbsp;&nbsp; 3.2 Add a grade file and the course name with the flags a `--name` and `--path`. This way a CourseNameStats.md file with the exam statistics will be created
