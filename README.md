# Cmus-analytics
Find [DEMO here](https://rafapaezbas.github.io/cmus-analytics/docs/index.html)
## What is Cmus-analytics?
A small web application for data visualization extracted from a Cmus log file. Click on the example link and then import it.
## How can I get a Cmus log file?
[Cmus](https://cmus.github.io/) is a very powerful music player with a lot possibilities. One of them is using a hook script for actions when the player status changes. With this script, you can create your own Cmus log file.
## How do I set the script in Cmus?
First, you will have to modify the script in order to make it work in your computer. Change the path of the log file.

```sh 
if [[ "$is_playing" = true ]] && [[ "$is_logging" = true ]]
then
    echo $entry >> {path_to_the_log_file}
fi
```

In Cmus use
```
:set status_display_program {path_to_the_script}
```
## Can I use this code somehow?
Yes, of course! Please be so kind to do it. This application has been developed as a learning project of the Elm programing language. It also uses this awesome Elm [linear charts library](https://github.com/terezka/line-charts/).
