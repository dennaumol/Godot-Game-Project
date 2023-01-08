shader_type canvas_item;

uniform vec4 OLDCOLOR1 : hint_color;
uniform vec4 OLDCOLOR2 : hint_color;
uniform vec4 OLDCOLOR3 : hint_color;
uniform vec4 OLDCOLOR4 : hint_color;

uniform vec4 NEWCOLOR1 : hint_color;
uniform vec4 NEWCOLOR2 : hint_color;
uniform vec4 NEWCOLOR3 : hint_color;
uniform vec4 NEWCOLOR4 : hint_color;

void fragment() {
    vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel
	
	//Lets check that our current pixel colour is any of the OLDCOLORs we wish to swap
	//If our pixel is an old colour then swap COLOR to NEWCOLOR, very simple
    if (distance(curr_color, OLDCOLOR1) < 0.1)
	{
        COLOR = NEWCOLOR1;
    }
	else if (distance(curr_color, OLDCOLOR2) < 0.1)
	{
        COLOR = NEWCOLOR2;
    }
	else if (distance(curr_color, OLDCOLOR3) < 0.1)
	{
        COLOR = NEWCOLOR3;
    }
	else if (distance(curr_color, OLDCOLOR4) < 0.1)
	{
        COLOR = NEWCOLOR4;
    }
	else
	{
		//We didn't find any old colors for this pixel so keep it's original color
        COLOR = curr_color;
    }
}