The power of **kwargs. => Sometimes it is just great to require the calling code to pass args as kwargs. It makes it more visible when calling and when accepting. And more flexible when changing the code.

Context-managers. Love them. They hide away the before-and-after. It's just neater to say
with handle_stuff():
  do_my_actual_thing()
then
do_something()
and_another_thing()
do_my_actual_thing()
now_do_some_cleanup_too()


Dev mantra: trust nobody. 
What makes a dev a great dev: they can see where the code can fail and prepare for these scenarios.
