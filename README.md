# so2twitter-poster

Bot for posting new Stackoverflow questions to Twitter, created in Salesforce.

[![release](https://img.shields.io/badge/release-v0.2-brightgreen.png?style=default)](https://github.com/last-khajiit/so2twitter-poster/releases/latest) [![Build Status](https://travis-ci.org/last-khajiit/so2twitter-poster.svg?branch=master)](https://travis-ci.org/last-khajiit/so2twitter-poster)

Bot aggregates Stackoverflow questions over the past 24 hours, and tweets their. You can note exact tags for questions and choose - should it look for only unanswered questions or not.

Settings page:
![Screenshot](images/settings-page.png)

[My twitter-bot (as an example)](https://twitter.com/boguslau_ducker):
![Screenshot](images/twitter-bot-screenshot.png)

###Deploy and configuration 
1. <a href="https://githubsfdeploy.herokuapp.com/?owner=last-khajiit&repo=so2twitter-poster">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>
2. Use your Twitter acc for creation Twitter app [https://apps.twitter.com/](https://apps.twitter.com/)
3. Go to Salesforce "So2Twitter Poster settings" tab and fill all the necessary settings  (use twitter-related from previous step)
4. For scheduling iterative execution click "Scheduled job" link, past *SO2TP_ScheduleTweetGenerator* in Job Name and Apex Class fields and set Frequency
5. For validation of correct configuring to click "Aggregate now" button and check job execution results in Twitter

###Known issues and future improvements:
1. Add processing of all retrieved questions (not only first result page)
2. Fix issue with multiple tags (future methods-related)
3. Improve integration with Twitter (replace manual configuration with 'Allow access..' ability)



*Feel free to make pull requests!*


---

**Copyright © 2016 Last Khajiit <last.khajiit@gmail.com>**

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the [COPYING](copying.txt) file for more details.
