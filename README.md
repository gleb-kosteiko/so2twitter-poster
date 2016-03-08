# so2twitter-poster

<a href="https://githubsfdeploy.herokuapp.com/?owner=last-khajiit&repo=so2twitter-poster">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

[![release](https://img.shields.io/badge/release-v0.2-brightgreen.png?style=default)](https://github.com/last-khajiit/so2twitter-poster/releases/latest) [![Build Status](https://travis-ci.org/last-khajiit/so2twitter-poster.svg?branch=master)](https://travis-ci.org/last-khajiit/so2twitter-poster) [![HitCount](https://hitt.herokuapp.com/last-khajiit/so2twitter-poster.svg)](https://github.com/last-khajiit/so2twitter-poster)

Bot for posting new Stackoverflow questions to Twitter, created in Salesforce.

Bot aggregates Stackoverflow questions over the past 24 hours, and tweets their. You can note exact tags for questions and choose - should it look for only unanswered questions or not.

![Screenshot](images/settings-page.png)

###Deploy and configuration 
1. Click "Deploy to Salesforce" button or clone and deploy it manually
2. Use your Twitter acc for creation Twitter app [https://apps.twitter.com/](https://apps.twitter.com/)
3. Go to Salesforce "So2Twitter Poster settings" tab and fill all the necessary settings  (use twitter-related from previous step)
4. Click "Start aggregation" button and check job execution results in Twitter
5. Go to Setup -> Develop -> Apex Classes and schedule "SO2TP_ScheduleTweetGenerator" class for daily execution

###ToDo
1. Add processing of all retrieved questions (not only first result page)
2. Fix issue with multiple tags (future methods-related)
3. Add an exception processing & validation
4. Fix the issue with quotes in tweets



*Feel free to make pull requests!*


---

**Copyright © 2016 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](copying.txt) file for more details.
