import sys
import random
import time

is_paused = False
mouse_x = 0
mouse_y = 0
shift_x = 0
shift_y = 0
brush = 0
rows = 40
columns = 40
speed = 2
detect_color = False
is_in_fullscreen = True
is_initialized = 0
detected_color = "0x000000"
color_variance = 30
pixel_searched = 0
pixel_found = 0
circle_top = 210
circle_left = -970
circle_bottom = 880
circle_right = -300
horizontal_square = 1
vertical_square = 1
shift_x_square = 0
shift_y_square = 0
square_time = 20
zoom_loop = 0

def on_initialize():
	circle_right = circle_left + 670
	circle_bottom = circle_top + 670
	is_initialized = 1

def on_exit():
    sys.exit("Program closed")
    
def move():
    if horizontal_square > 1 and vertical_square > 1:
        shift_x_square = 0
        shift_y_square = 0
        horizontal_square_loop = 0
        
        while horizontal_square_loop != vertical_square:
            horizontal_square_loop += 1
            vertical_square_loop = 0
            
            while vertical_square_loop != horizontal_square:
					vertical_square_loop += 1
					mouse_click("left", circle_left + 50 , circle_bottom - 80)
					test_zoom()
					mouse_click("left", ((circle_left + circle_right) / 2) + shift_x_square, ((circle_top + circle_bottom) / 2) + shift_y_square) 
					test_zoom()
					shift_y_square = 0
					square()
					
					if horizontal_square_loop % 2 == 0:
						shift_x_square = -columns / 10 * 13
					else:
						shift_x_square = -columns / 10 * 13
			
			shift_y_square = rows / 10 * 13
			shift_x_square = 0
	else:
	    square()
	    
def test_zoom()
    zoom_loop = 2
	pixel_searched = 0
	
	sleep(square_time * 200)
	
	while zoom_loop < 10:
		pixel_searched = pixel_search(circle_left + 30, circle_bottom - 50, circle_left + 130, circle_bottom - 35, "0xFFFFFF" , 80)
		if not pixel_searched: # Error.
			sleep(500)
			return None
		else:
			sleep(square_time * 100)
			zoom_loop = zoom_loop + 1
			
def on_stop()
    while True:
        loop_1 = 0
		loop_2 = 0
		loop_3 = 0
		shift_x = 0
		shift_y = 0
		if not is_paused:
		    is_paused = True
		    on_pause()
		else:
		    is_paused = False
		    mouse_x = mouse_get_x()
		    mouse_y = mouse_get_y()
		    move()

def on_pause():
    while is_paused:
        sleep(500)
        
def square():
    sleep(500)
	shift_x = 0
	shift_y = 0
	loop_2 = 0
    
    while loop_2 <= (rows * 12 / brush):
        loop_2 += 1
        loop_3 = 0

        if loop_2 % 2 == 0:
            shift_x -= (brush / 2)
        else:
            shift_x += (brush / 2)

        while loop_3 <= (columns * 10 / brush):
            loop_3 += 1

            if detect_color:
                if loop_1 == 1 and loop_2 == 1 and loop_3 == 1:
                    mouse_click("left", mouse_x + shift_x, mouse_y + shift_y, 1, speed)
                    sleep(100)
                    mouse_move(mouse_x + shift_x + (brush * 2), mouse_y + shift_y, 0)
                    sleep(100)
                    detected_color = pixel_get_color(mouse_x + shift_x, mouse_y + shift_y)
                    sleep(100)
                else:
                    pixel_searched = pixel_search(mouse_x + shift_x, mouse_y + shift_y - brush / 4, mouse_x + shift_x, mouse_y + shift_y - brush / 4, detected_color, color_variance)
                    if not pixel_found: # Error.
                        pixel_found += 1
                    pixel_searched = pixel_search(mouse_x + shift_x - brush / 4, mouse_y + shift_y + brush / 4, mouse_x + shift_x - brush / 4, mouse_y + shift_y + brush / 4, detected_color, color_variance)
                    if not pixel_found: # Error.
                        pixel_found += 1
                    pixel_searched = pixel_search(mouse_x + shift_x + brush / 4, mouse_y + shift_y + brush / 4, mouse_x + shift_x + brush / 4, mouse_y + shift_y + brush / 4, detected_color, color_variance)
                    if not pixel_found: # Error.
                        pixel_found += 1
                    if pixel_found > 1:
                        mouse_click("left", mouse_x + shift_x, mouse_y + shift_y, 1, speed)
                    else:
                        mouse_move(mouse_x + shift_x, mouse_y + shift_y, 0)
            else:
                mouse_click("left", mouse_x + shift_x, mouse_y + shift_y, 1, speed)

            if loop_2 % 2 == 0:
                shift_x -= brush
            else:
                shift_x += brush

        if is_in_fullscreen:
            shift_y += = ((brush / 5) * 4)
        else:
            shift_y += = ((brush / 4) * 3)

def main():
    # Quit: ALT + q
    # Stop: ALT + x
    
    #random.seed(time.time())
	program_info = "pownball 0.8.0"
	
	run_string = "Run"
	run_event = "on_first"
	
	rows_string = "Rows"
	
	columns_string = "Columns"

	spacing_string = "Spacing"
	
	detect_color_string = "Color detection"
	
	color_variance_string = "Color variance"
	
	speed_string = "Speed"
	
	circle_left_string = "Left"
	circle_top_string = "Top"
	
	horizontal_square_string = "Horizontal square"
	vertical_square_string = "Vertical square"
	
	exit_event = "on_exit"

	while is_initialized == 0:
	    sleep(50)
	
	on_stop()

if __name__ == "__main__":
    main()

