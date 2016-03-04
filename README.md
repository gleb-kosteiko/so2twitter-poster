# so2twitter-poster-bot

[![Build Status](https://travis-ci.org/last-khajiit/so2twitter-poster-bot.svg?branch=master)](https://travis-ci.org/last-khajiit/so2twitter-poster-bot)

Bot for posting new Stackoverflow questions to Twitter, created in Salesforce

![Screenshot](settings-page.png)

###Deploy and configuration 
1. Clone the project and deploy to your SF org
2. Go to "So2Twitter Poster settings" tab and fill all the necessary settings 
3. Go to Setup -> Develop -> Apex Classes and schedule "SO2TP_ScheduleTweetGenerator" class for daily execution
4. Click "Start aggregation" button and check job execution results

###ToDo
1. Add validation for duplicate questions
2. Add processing of all retrieved questions (not only first result page)
3. Add statistics about previous job execution, exception validation, etc


*Feel free to make pull requests!*


---

**Copyright © 2016 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](copying.txt) file for more details.
