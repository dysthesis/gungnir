# dwl

I'm not sure if the changes made to `minimalborders` reflect accurately the proper usage of the `draw_borders` parameter introduced by `smartborders`. While the current approach is to set `draw_borders` to 0 if the client is in fullscreen, there is an different usage in the function `tile()` that counts visible, non-floating, and non-fullscreen cleints in the monitor and draws no border if the count is 1. That looks more correct, but I'm not sure if the other functions needs to perform this check anyways, since `tile()` already does.
