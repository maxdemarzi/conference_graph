conference_graph
================

POC for mapping the Social Graph of Conferences


General Idea
------------

The idea is to use the power of the graph to allow attendees to kick ass.

Means that we think we can create a supereasy heroku/sinatra/neography app with some 
REST endpoints for putting in the data and, either a mobile client or mobile & desktop webpage 
(supersimple) that allows to create a conference graph and then gather information from attendees 
like votes on sessions, planning data, likes and interestes and other (non-related) questions.
I think the app should use cypher for most operations.

Perhaps get some local meetup members to come along and help us (in neo4j shirts) with the data gathering, 
e.g. also wait for attendees after sessions to collect their votes.
Also employ twitter to collect information about who is at the conference 
(tweets with the conference hashtag and some emotions)

Then we'd like to offere the following:
- recommendations for sessions
- find people similar to you
- collaborative filtering
- overview of the day
- predict attendance of sessions (which rooms will be full)
- some neat graphics of the conference
- some cool tweet viz (like visibiletweets.com but in JS instead of flash)

So that people can actually see and experience the power of the graph in a well known setting.

Andreas brought in the idea of politicizing it a bit in election year by having our data collectors 
also go round and ask some political questions and doing collaborative filtering on those.

How to integrate our RFID tags (with proxmity sighting, http://www.openbeacon.org/BruCON_2011) that we 
ordered for graphconnect into this, my idea is to add the tag id to the rel between person and conference) 
and then use the gathered RFID data (positions, chats, activities) to add a "active social" layer 
to the conference graph - who talked with whom, which can be collected unobtrusively

Plan
------------

I think we would go with auto-indexing (that's why the main name property is the object type  instead of "name")

I thought as zero iteration just have rest endpoints for POST (json object) and GET of 

- person (twitter, name, github, url, picture-url, bio)
- conference (conference==name, text, venue, logo, url, start, end, organizers(aka persons)
- track (track==name, text, room, [start, end])
- session (session==name, text, slides-url, start, runtime (speaker(s) aka persons), track)

- POST endpoints for creating planned, attended(vote property) relationships to sessions
- POST endpoint for attends relationship to the whole conference

- and a generic cypher endpoint

That would be the minimum.

2nd iteration
Then some simplistic CRUD webpage for creating the stuff (instead of curl), esp. the attendee registration

One or two nice visualizations of the conference structure (like the ask-ken?)

One simple webpage (also working on mobile) to favorite/plan sessions
One simple webpage (also working on mobile) to vote on an attended session (the red,yellow, green - touch areas of qcon/jaoo) 

3rd iteration
visualization of attendance / planning / votes
visualization of clusters in the people graph

