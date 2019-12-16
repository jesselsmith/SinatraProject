# Welcome to Adventurer's Log!

Adventurer's Log is a system for keeping track of your Dungeons and Dragons characters, with a particular eye for characters in Adventurers' League!

Sign up for an account, and then you will be able to make any number of characters, and log each session that character plays! Adventure Logger will keep track of the most important statistics of your character -- your level, your gold, your magic items, and more!

There is no account recovery procedure as of yet, so don't lose your password!

# Setup
Once you fork and clone the repo, you'll need bundle all the gems:

```
$ bundle install
```

After bundling is complete, you'll need to set up an environment variable for the session secret, so that password hashing works properly and securely. [Check out this Sinatra readme on how to set that up,](https://github.com/sinatra/sinatra#using-sessions) under "Session Secret Generation (Bonus Points)" and "Session Secret Environment Variable". For more info on setting an environment variable, check out [this guide for Mac](https://medium.com/@himanshuagarwal1395/setting-up-environment-variables-in-macos-sierra-f5978369b255), [this guide for Linux](https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-environment-variables-in-linux/), or [this guide for Windows](https://www.computerhope.com/issues/ch000549.htm).

Once you have set that all up properly, while in the directory of Adventurer's Log, enter rackup into your terminal:
```
$ rackup
```
This will start the server locally. To access Adventurer's Log, navigate to localhost:9292 in your web browser. Then sign up for an account and happy logging!

# Contributer's Guide


## Raising an Issue to Encourage a Contribution

If you notice a problem with the project that you believe needs improvement
but you're unable to make the change yourself, you should raise a Github issue
containing a clear description of the problem. Include relevant snippets of
the content and/or screenshots if applicable. I regularly review
issue lists and your issue will be prioritized and addressed as appropriate.

## Submitting a Pull Request to Suggest an Improvement

If you see an opportunity for improvement and can make the change yourself go
ahead and use a typical git workflow to make it happen:

* Fork this curriculum repository
* Make the change on your fork, with descriptive commits in the standard format
* Open a Pull Request against this repo

I will review the changes and approve or comment on them in due course.

Adapted from Learn contributing guide.

# License

https://github.com/jesselsmith/SinatraProject/blob/master/LICENSE