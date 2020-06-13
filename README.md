This is the code I use to run a Twitter bot: https://www.twitter.com/Frybot2

Try out the generator with:

```
# ruby interpreter e.g. irb or pry

> require './good_morning.rb'
> try_out
```

To add more synonyms for 'say' or more adverbs:

1) append to say_synonyms.txt or adverbs.txt.
2) run `ruby remove_duplicate_lines.rb`

twitter.rb posts to Twitter.

The cronjob I use to run twitter.rb every five hours on my laptop was:

```
0 */5 * * * cd ~/projects/[repo] && ruby twitter.rb
```

`crontab -l` to see all cronjobs

`crontab -e` to edit
