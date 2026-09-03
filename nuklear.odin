/**
 * Nuklear
 * Single-header ANSI C immediate mode cross-platform GUI library.
 *
 * VERSION:
 *     v4.13.3
 *
 * HOMEPAGE:
 *     https://github.com/Immediate-Mode-UI/Nuklear/
 *
 * ABOUT:
 *     This is a minimal state immediate mode graphical user interface toolkit
 *     written in ANSI C and licensed under public domain. It was designed as a simple
 *     embeddable user interface for application and does not have any dependencies,
 *     a default renderbackend or OS window and input handling but instead provides a very modular
 *     library approach by using simple input state for input and draw
 *     commands describing primitive shapes as output. So instead of providing a
 *     layered library that tries to abstract over a number of platform and
 *     render backends it only focuses on the actual UI.
 *
 * HIGHLIGHTS:
 *     - Graphical user interface toolkit
 *     - Single header library
 *     - Written in C89 (a.k.a. ANSI C or ISO C90)
 *     - Small codebase (~18kLOC)
 *     - Focus on portability, efficiency and simplicity
 *     - No dependencies (not even the standard library if not wanted)
 *     - Fully skinnable and customizable
 *     - Low memory footprint with total memory control if needed or wanted
 *     - UTF-8 support
 *     - No global or hidden state
 *     - Customizable library modules (you can compile and use only what you need)
 *     - Optional font baker and vertex buffer output
 *
 * FEATURES:
 *    - Absolutely no platform dependent code
 *    - Memory management control ranging from/to
 *        - Ease of use by allocating everything from standard library
 *        - Control every byte of memory inside the library
 *    - Font handling control ranging from/to
 *        - Use your own font implementation for everything
 *        - Use this libraries internal font baking and handling API
 *    - Drawing output control ranging from/to
 *        - Simple shapes for more high level APIs which already have drawing capabilities
 *        - Hardware accessible anti-aliased vertex buffer output
 *    - Customizable colors and properties ranging from/to
 *        - Simple changes to color by filling a simple color table
 *        - Complete control with ability to use skinning to decorate widgets
 *    - Bendable UI library with widget ranging from/to
 *        - Basic widgets like buttons, checkboxes, slider, ...
 *        - Advanced widget like abstract comboboxes, contextual menus,...
 *    - Compile time configuration to only compile what you need
 *        - Subset which can be used if you do not want to link or use the standard library
 *    - Can be easily modified to only update on user input instead of frame updates
 *
 * USAGE:
 * This library is self contained in one single header file and can be used either
 * in header only mode or in implementation mode. The header only mode is used
 * by default when included and allows including this header in other headers
 * and does not contain the actual implementation.
 * The implementation mode requires to define the preprocessor macro
 * NK_IMPLEMENTATION in *one* .c/.cpp file before #including this file, e.g.:
 *
 *     #define NK_IMPLEMENTATION
 *     #include "nuklear.h"
 *
 * Also optionally define the symbols listed in the section "OPTIONAL DEFINES"
 * below in header and implementation mode if you want to use additional functionality
 * or need more control over the library.
 *
 * @warning Every time nuklear is included define the same compiler flags. This is very
 * important — not doing so could lead to compiler errors or even worse stack corruptions.
 *
 * @subsection flags Flags
 * Flag                            | Description
 * --------------------------------|------------------------------------------
 * NK_PRIVATE                      | If defined declares all functions as static, so they can only be accessed inside the file that contains the implementation
 * NK_INCLUDE_FIXED_TYPES          | If defined it will include header `<stdint.h>` for fixed sized types otherwise nuklear tries to select the correct type. If that fails it will throw a compiler error and you have to select the correct types yourself.
 * NK_INCLUDE_DEFAULT_ALLOCATOR    | If defined it will include header `<stdlib.h>` and provide additional functions to use this library without caring for memory allocation control and therefore ease memory management.
 * NK_INCLUDE_STANDARD_IO          | If defined it will include header `<stdio.h>` and provide additional functions depending on file loading.
 * NK_INCLUDE_STANDARD_VARARGS     | If defined it will include header `<stdarg.h>` and provide additional functions depending on file loading.
 * NK_INCLUDE_STANDARD_BOOL        | If defined it will include header `<stdbool.h>` for nk_bool otherwise nuklear defines nk_bool as int.
 * NK_INCLUDE_VERTEX_BUFFER_OUTPUT | Defining this adds a vertex draw command list backend to this library, which allows you to convert queue commands into vertex draw commands. This is mainly if you need a hardware accessible format for OpenGL, DirectX, Vulkan, Metal,...
 * NK_INCLUDE_FONT_BAKING          | Defining this adds `stb_truetype` and `stb_rect_pack` implementation to this library and provides font baking and rendering. If you already have font handling or do not want to use this font handler you don't have to define it.
 * NK_INCLUDE_DEFAULT_FONT         | Defining this adds the default font: ProggyClean.ttf into this library which can be loaded into a font atlas and allows using this library without having a truetype font
 * NK_INCLUDE_COMMAND_USERDATA     | Defining this adds a userdata pointer into each command. Can be useful for example if you want to provide custom shaders depending on the used widget. Can be combined with the style structures.
 * NK_BUTTON_TRIGGER_ON_RELEASE    | Different platforms require button clicks occurring either on buttons being pressed (up to down) or released (down to up). By default this library will react on buttons being pressed, but if you define this it will only trigger if a button is released.
 * NK_ZERO_COMMAND_MEMORY          | Defining this will zero out memory for each drawing command added to a drawing queue (inside nk_command_buffer_push). Zeroing command memory is very useful for fast checking (using memcmp) if command buffers are equal and avoid drawing frames when nothing on screen has changed since previous frame.
 * NK_UINT_DRAW_INDEX              | Defining this will set the size of vertex index elements when using NK_VERTEX_BUFFER_OUTPUT to 32bit instead of the default of 16bit
 * NK_KEYSTATE_BASED_INPUT         | Define this if your backend uses key state for each frame rather than key press/release events
 * NK_IS_WORD_BOUNDARY(c)          | Define this to a function macro that takes a single nk_rune (nk_uint) and returns true if it's a word separator. If not defined, uses the default definition (see nk_is_word_boundary())
 *
 * @warning The following flags will pull in the standard C library:
 * - NK_INCLUDE_DEFAULT_ALLOCATOR
 * - NK_INCLUDE_STANDARD_IO
 * - NK_INCLUDE_STANDARD_VARARGS
 *
 * @warning The following flags if defined need to be defined for both header and implementation:
 * - NK_INCLUDE_FIXED_TYPES
 * - NK_INCLUDE_DEFAULT_ALLOCATOR
 * - NK_INCLUDE_STANDARD_VARARGS
 * - NK_INCLUDE_STANDARD_BOOL
 * - NK_INCLUDE_VERTEX_BUFFER_OUTPUT
 * - NK_INCLUDE_FONT_BAKING
 * - NK_INCLUDE_DEFAULT_FONT
 * - NK_INCLUDE_COMMAND_USERDATA
 * - NK_UINT_DRAW_INDEX
 *
 * @subsection constants Constants
 * Define                          | Description
 * --------------------------------|---------------------------------------
 * NK_BUFFER_DEFAULT_INITIAL_SIZE  | Initial buffer size allocated by all buffers while using the default allocator functions included by defining NK_INCLUDE_DEFAULT_ALLOCATOR. If you don't want to allocate the default 4k memory then redefine it.
 * NK_MAX_NUMBER_BUFFER            | Maximum buffer size for the conversion buffer between float and string. Under normal circumstances this should be more than sufficient.
 * NK_INPUT_MAX                    | Defines the max number of bytes which can be added as text input in one frame. Under normal circumstances this should be more than sufficient.
 *
 * @warning The following constants if defined need to be defined for both header and implementation:
 * - NK_MAX_NUMBER_BUFFER
 * - NK_BUFFER_DEFAULT_INITIAL_SIZE
 * - NK_INPUT_MAX
 *
 * @subsection dependencies Dependencies
 * Function     | Description
 * -------------|---------------------------------------------------------------
 * NK_ASSERT    | If you don't define this, nuklear will use `<assert.h>` with assert().
 * NK_MEMSET    | You can define this to 'memset' or your own memset implementation replacement. If not nuklear will use its own version.
 * NK_MEMCPY    | You can define this to 'memcpy' or your own memcpy implementation replacement. If not nuklear will use its own version.
 * NK_INV_SQRT  | You can define this to your own inverse sqrt implementation replacement. If not nuklear will use its own slow and not highly accurate version.
 * NK_SIN       | You can define this to 'sinf' or your own sine implementation replacement. If not nuklear will use its own approximation implementation.
 * NK_COS       | You can define this to 'cosf' or your own cosine implementation replacement. If not nuklear will use its own approximation implementation.
 * NK_STRTOD    | You can define this to `strtod` or your own string to double conversion implementation replacement. If not defined nuklear will use its own imprecise and possibly unsafe version (does not handle nan or infinity!).
 * NK_DTOA      | You can define this to `dtoa` or your own double to string conversion implementation replacement. If not defined nuklear will use its own imprecise and possibly unsafe version (does not handle nan or infinity!).
 * NK_VSNPRINTF | If you define `NK_INCLUDE_STANDARD_VARARGS` as well as `NK_INCLUDE_STANDARD_IO` and want to be safe define this to `vsnprintf` on compilers supporting later versions of C or C++. By default nuklear will check for your stdlib version in C as well as compiler version in C++. if `vsnprintf` is available it will define it to `vsnprintf` directly. If not defined and if you have older versions of C or C++ it will be defined to `vsprintf` which is unsafe.
 *
 * @warning The following dependencies will pull in the standard C library if not redefined:
 * - NK_ASSERT
 *
 * @warning The following dependencies if defined need to be defined for both header and implementation:
 * - NK_ASSERT
 *
 * @warning The following dependencies if defined need to be defined only for the implementation part:
 * - NK_MEMSET
 * - NK_MEMCPY
 * - NK_SQRT
 * - NK_SIN
 * - NK_COS
 * - NK_STRTOD
 * - NK_DTOA
 * - NK_VSNPRINTF
 *
 * @section example Example
 *
 * ```c
 * // init gui state
 * enum {EASY, HARD};
 * static int op = EASY;
 * static float value = 0.6f;
 * static int i =  20;
 * struct nk_context ctx;
 *
 * nk_init_fixed(&ctx, calloc(1, MAX_MEMORY), MAX_MEMORY, &font);
 * if (nk_begin(&ctx, "Show", nk_rect(50, 50, 220, 220),
 *     NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_CLOSABLE)) {
 *     // fixed widget pixel width
 *     nk_layout_row_static(&ctx, 30, 80, 1);
 *     if (nk_button_label(&ctx, "button")) {
 *         // event handling
 *     }
 *
 *     // fixed widget window ratio width
 *     nk_layout_row_dynamic(&ctx, 30, 2);
 *     if (nk_option_label(&ctx, "easy", op == EASY)) op = EASY;
 *     if (nk_option_label(&ctx, "hard", op == HARD)) op = HARD;
 *
 *     // custom widget pixel width
 *     nk_layout_row_begin(&ctx, NK_STATIC, 30, 2);
 *     {
 *         nk_layout_row_push(&ctx, 50);
 *         nk_label(&ctx, "Volume:", NK_TEXT_LEFT);
 *         nk_layout_row_push(&ctx, 110);
 *         nk_slider_float(&ctx, 0, &value, 1.0f, 0.1f);
 *     }
 *     nk_layout_row_end(&ctx);
 * }
 * nk_end(&ctx);
 * ```
 */
package nuklear

import "core:c"

/*
* ==============================================================
*
*                          CONSTANTS
*
* ===============================================================
*/
UNDEFINED                :: (-1.0)
UTF_SIZE                 :: 4 /**< describes the number of bytes a glyph consists of*/
INPUT_MAX                :: 16
MAX_NUMBER_BUFFER        :: 64
SCROLLBAR_HIDING_TIMEOUT :: 4.0
INT8                     :: i8
UINT8                    :: u8
INT16                    :: i16
UINT16                   :: u16
INT32                    :: i32
UINT32                   :: u32
SIZE_TYPE                :: c.uintptr_t
POINTER_TYPE             :: c.uintptr_t

Hash   :: u32
Flags  :: u32
color  :: [4]byte
colorf :: [4]f32
vec2   :: [2]f32
Vec2I  :: [2]i16

rect :: struct {
	x, y, w, h: f32,
}

RectI :: struct {
	x, y, w, h: i16,
}

glyph :: [4]i8

handle :: struct #raw_union {
	ptr: rawptr,
	id:  i32,
}

image :: struct {
	handle: handle,
	w, h:   u16,
	region: [4]u16,
}

nine_slice :: struct {
	img:        image,
	l, t, r, b: u16,
}

cursor :: struct {
	img:          image,
	size, offset: vec2,
}

scroll :: struct {
	x, y: u32,
}

heading :: enum u32 {
	UP    = 0,
	RIGHT = 1,
	DOWN  = 2,
	LEFT  = 3,
}

button_behavior :: enum u32 {
	DEFAULT  = 0,
	REPEATER = 1,
}

modify :: enum u32 {
	FIXED      = 0,
	MODIFIABLE = 1,
}

orientation :: enum u32 {
	VERTICAL   = 0,
	HORIZONTAL = 1,
}

collapse_states :: enum i32 {
    MINIMIZED = 0,
    MAXIMIZED = 1,
}

show_states :: enum u32 {
	HIDDEN = 0,
	SHOWN  = 1,
}

chart_type :: enum u32 {
	LINES  = 0,
	COLUMN = 1,
}

chart_event :: enum u32 {
	HOVERING = 0,
	CLICKED  = 1,
}

color_format :: enum u32 {
	RGB  = 0,
	RGBA = 1,
}

chart_event_Flags :: bit_set[chart_event; u32]

popup_type :: enum u32 {
	STATIC  = 0,
	DYNAMIC = 1,
}

layout_format :: enum u32 {
	DYNAMIC = 0,
	STATIC  = 1,
}

tree_type :: enum u32 {
	NODE = 0,
	TAB  = 1,
}

tooltip_pos :: enum u32 {
	TOP_LEFT      = 0,
	TOP_CENTER    = 1,
	TOP_RIGHT     = 2,
	MIDDLE_LEFT   = 3,
	MIDDLE_CENTER = 4,
	MIDDLE_RIGHT  = 5,
	BOTTOM_LEFT   = 6,
	BOTTOM_CENTER = 7,
	BOTTOM_RIGHT  = 8,
}

plugin_alloc  :: proc "c" (_: handle, old: rawptr, _: uint) -> rawptr
plugin_free   :: proc "c" (_: handle, old: rawptr)
plugin_filter :: proc "c" (_: ^text_edit, unicode: rune) -> bool
plugin_paste  :: proc "c" (handle, ^text_edit)
plugin_copy   :: proc "c" (_: handle, _: cstring, len: i32)
allocator     :: struct {}

symbol_type :: enum u32 {
	NONE                   = 0,
	X                      = 1,
	UNDERSCORE             = 2,
	CIRCLE_SOLID           = 3,
	CIRCLE_OUTLINE         = 4,
	RECT_SOLID             = 5,
	RECT_OUTLINE           = 6,
	TRIANGLE_UP            = 7,
	TRIANGLE_DOWN          = 8,
	TRIANGLE_LEFT          = 9,
	TRIANGLE_RIGHT         = 10,
	PLUS                   = 11,
	MINUS                  = 12,
	TRIANGLE_UP_OUTLINE    = 13,
	TRIANGLE_DOWN_OUTLINE  = 14,
	TRIANGLE_LEFT_OUTLINE  = 15,
	TRIANGLE_RIGHT_OUTLINE = 16,
	CHEVRON_UP             = 17,
	CHEVRON_RIGHT          = 18,
	CHEVRON_DOWN           = 19,
	CHEVRON_LEFT           = 20,
	HAMBURGER              = 21, /** Three horizontal lines. */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/**
	* # nk_init_fixed
	* Initializes a `nk_context` struct from single fixed size memory block
	* Should be used if you want complete control over nuklear's memory management.
	* Especially recommended for system with little memory or systems with virtual memory.
	* For the later case you can just allocate for example 16MB of virtual memory
	* and only the required amount of memory will actually be committed.
	*
	* ```c
	* nk_bool nk_init_fixed(struct nk_context *ctx, void *memory, nk_size size, const struct nk_user_font *font);
	* ```
	*
	* \warning Make sure the passed memory block is aligned correctly for `nk_draw_commands`.
	*
	* Parameter   | Description
	* ------------|--------------------------------------------------------------
	* \param[in] ctx     | Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] memory  | Must point to a previously allocated memory block
	* \param[in] size    | Must contain the total size of memory
	* \param[in] font    | Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	init_fixed :: proc(_: ^context, memory: rawptr, size: uint, _: ^user_font) -> bool ---

	/**
	* # nk_init
	* Initializes a `nk_context` struct with memory allocation callbacks for nuklear to allocate
	* memory from. Used internally for `nk_init_default` and provides a kitchen sink allocation
	* interface to nuklear. Can be useful for cases like monitoring memory consumption.
	*
	* ```c
	* nk_bool nk_init(struct nk_context *ctx, const struct nk_allocator *alloc, const struct nk_user_font *font);
	* ```
	*
	* Parameter   | Description
	* ------------|---------------------------------------------------------------
	* \param[in] ctx     | Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] alloc   | Must point to a previously allocated memory allocator
	* \param[in] font    | Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	init :: proc(^context, ^allocator, ^user_font) -> bool ---

	/**
	* \brief Initializes a `nk_context` struct from two different either fixed or growing buffers.
	*
	* \details
	* The first buffer is for allocating draw commands while the second buffer is
	* used for allocating windows, panels and state tables.
	*
	* ```c
	* nk_bool nk_init_custom(struct nk_context *ctx, struct nk_buffer *cmds, struct nk_buffer *pool, const struct nk_user_font *font);
	* ```
	*
	* \param[in] ctx    Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] cmds   Must point to a previously initialized memory buffer either fixed or dynamic to store draw commands into
	* \param[in] pool   Must point to a previously initialized memory buffer either fixed or dynamic to store windows, panels and tables
	* \param[in] font   Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	init_custom :: proc(_: ^context, cmds: ^buffer, pool: ^buffer, _: ^user_font) -> bool ---

	/**
	* \brief Resets the context state at the end of the frame.
	*
	* \details
	* This includes mostly garbage collector tasks like removing windows or table
	* not called and therefore used anymore.
	*
	* ```c
	* void nk_clear(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx  Must point to a previously initialized `nk_context` struct
	*/
	clear :: proc(^context) ---

	/**
	* \brief Frees all memory allocated by nuklear; Not needed if context was initialized with `nk_init_fixed`.
	*
	* \details
	* ```c
	* void nk_free(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx  Must point to a previously initialized `nk_context` struct
	*/
	free :: proc(^context) ---

	/**
	* \brief Sets the currently passed userdata passed down into each draw command.
	*
	* \details
	* ```c
	* void nk_set_user_data(struct nk_context *ctx, nk_handle data);
	* ```
	*
	* \param[in] ctx Must point to a previously initialized `nk_context` struct
	* \param[in] data  Handle with either pointer or index to be passed into every draw commands
	*/
	set_user_data :: proc(_: ^context, handle: handle) ---
}

/* =============================================================================
*
*                                  INPUT
*
* =============================================================================*/
/**
* \page Input
*
* The input API is responsible for holding the current input state composed of
* mouse, key and text input states.
* It is worth noting that no direct OS or window handling is done in nuklear.
* Instead all input state has to be provided by platform specific code. This on one hand
* expects more work from the user and complicates usage but on the other hand
* provides simple abstraction over a big number of platforms, libraries and other
* already provided functionality.
*
* ```c
* nk_input_begin(&ctx);
* while (GetEvent(&evt)) {
*     if (evt.type == MOUSE_MOVE)
*         nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*     else if (evt.type == [...]) {
*         // [...]
*     }
* } nk_input_end(&ctx);
* ```
*
* # Usage
* Input state needs to be provided to nuklear by first calling `nk_input_begin`
* which resets internal state like delta mouse position and button transitions.
* After `nk_input_begin` all current input state needs to be provided. This includes
* mouse motion, button and key pressed and released, text input and scrolling.
* Both event- or state-based input handling are supported by this API
* and should work without problems. Finally after all input state has been
* mirrored `nk_input_end` needs to be called to finish input process.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     Event evt;
*     nk_input_begin(&ctx);
*     while (GetEvent(&evt)) {
*         if (evt.type == MOUSE_MOVE)
*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*         else if (evt.type == [...]) {
*             // [...]
*         }
*     }
*     nk_input_end(&ctx);
*     // [...]
*     nk_clear(&ctx);
* } nk_free(&ctx);
* ```
*
* # Reference
* Function            | Description
* --------------------|-------------------------------------------------------
* \ref nk_input_begin  | Begins the input mirroring process. Needs to be called before all other `nk_input_xxx` calls
* \ref nk_input_motion | Mirrors mouse cursor position
* \ref nk_input_key    | Mirrors key state with either pressed or released
* \ref nk_input_button | Mirrors mouse button state with either pressed or released
* \ref nk_input_scroll | Mirrors mouse scroll values
* \ref nk_input_char   | Adds a single ASCII text character into an internal text buffer
* \ref nk_input_glyph  | Adds a single multi-byte UTF-8 character into an internal text buffer
* \ref nk_input_unicode| Adds a single unicode rune into an internal text buffer
* \ref nk_input_end    | Ends the input mirroring process by calculating state changes. Don't call any `nk_input_xxx` function referenced above after this call
*/
keys :: enum u32 {
	NONE              = 0,
	SHIFT             = 1,
	CTRL              = 2,
	DEL               = 3,
	ENTER             = 4,
	TAB               = 5,
	BACKSPACE         = 6,
	COPY              = 7,
	CUT               = 8,
	PASTE             = 9,
	UP                = 10,
	DOWN              = 11,
	LEFT              = 12,
	RIGHT             = 13,

	/* Shortcuts: text field */
	TEXT_INSERT_MODE  = 14,
	TEXT_REPLACE_MODE = 15,
	TEXT_RESET_MODE   = 16,
	TEXT_LINE_START   = 17,
	TEXT_LINE_END     = 18,
	TEXT_START        = 19,
	TEXT_END          = 20,
	TEXT_UNDO         = 21,
	TEXT_REDO         = 22,
	TEXT_SELECT_ALL   = 23,
	TEXT_WORD_LEFT    = 24,
	TEXT_WORD_RIGHT   = 25,

	/* Shortcuts: scrollbar */
	SCROLL_START      = 26,
	SCROLL_END        = 27,
	SCROLL_DOWN       = 28,
	SCROLL_UP         = 29,
	ALT               = 30,
	F1                = 31,
	F2                = 32,
	F3                = 33,
	F4                = 34,
	F5                = 35,
	F6                = 36,
	F7                = 37,
	F8                = 38,
	F9                = 39,
	F10               = 40,
	F11               = 41,
	F12               = 42,
}

buttons :: enum u32 {
	LEFT   = 0,
	MIDDLE = 1,
	RIGHT  = 2,
	DOUBLE = 3, /* Double click of the Left mouse button. */
	X1     = 4, /* Commonly used for "Back" in UI navigation. Mouse Button 4. */
	X2     = 5, /* Commonly used for "Forward" in UI navigation. Mouse Button 5. */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/**
	* \brief Begins the input mirroring process by resetting text, scroll
	* mouse, previous mouse position and movement as well as key state transitions.
	*
	* \details
	* ```c
	* void nk_input_begin(struct nk_context*);
	* ```
	*
	* \param[in] ctx Must point to a previously initialized `nk_context` struct
	*/
	input_begin :: proc(^context) ---

	/**
	* \brief Mirrors current mouse position to nuklear
	*
	* \details
	* ```c
	* void nk_input_motion(struct nk_context *ctx, int x, int y);
	* ```
	*
	* \param[in] ctx   Must point to a previously initialized `nk_context` struct
	* \param[in] x     Must hold an integer describing the current mouse cursor x-position
	* \param[in] y     Must hold an integer describing the current mouse cursor y-position
	*/
	input_motion :: proc(_: ^context, x: i32, y: i32) ---

	/**
	* \brief Mirrors the state of a specific key to nuklear
	*
	* \details
	* ```c
	* void nk_input_key(struct nk_context*, enum nk_keys key, nk_bool down);
	* ```
	*
	* \param[in] ctx      Must point to a previously initialized `nk_context` struct
	* \param[in] key      Must be any value specified in enum `nk_keys` that needs to be mirrored
	* \param[in] down     Must be 0 for key is up and 1 for key is down
	*/
	input_key :: proc(_: ^context, _: keys, down: bool) ---

	/**
	* \brief Mirrors the state of a specific mouse button to nuklear
	*
	* \details
	* ```c
	* void nk_input_button(struct nk_context *ctx, enum nk_buttons btn, int x, int y, nk_bool down);
	* ```
	*
	* \param[in] ctx     Must point to a previously initialized `nk_context` struct
	* \param[in] btn     Must be any value specified in enum `nk_buttons` that needs to be mirrored
	* \param[in] x       Must contain an integer describing mouse cursor x-position on click up/down
	* \param[in] y       Must contain an integer describing mouse cursor y-position on click up/down
	* \param[in] down    Must be 0 for key is up and 1 for key is down
	*/
	input_button :: proc(_: ^context, _: buttons, x: i32, y: i32, down: bool) ---

	/**
	* \brief Copies the last mouse scroll value to nuklear.
	*
	* \details
	* Is generally a scroll value. So does not have to come from mouse and could
	* also originate from balls, tracks, linear guide rails, or other programs.
	*
	* ```c
	* void nk_input_scroll(struct nk_context *ctx, struct nk_vec2 val);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] val     | vector with both X- as well as Y-scroll value
	*/
	input_scroll :: proc(_: ^context, val: vec2) ---

	/**
	* \brief Copies a single ASCII character into an internal text buffer
	*
	* \details
	* This is basically a helper function to quickly push ASCII characters into
	* nuklear.
	*
	* \note Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_char(struct nk_context *ctx, char c);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] c       | Must be a single ASCII character preferable one that can be printed
	*/
	input_char :: proc(^context, i8) ---

	/**
	* \brief Converts an encoded unicode rune into UTF-8 and copies the result into an
	* internal text buffer.
	*
	* \note Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_glyph(struct nk_context *ctx, const nk_glyph g);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] g       | UTF-32 unicode codepoint
	*/
	input_glyph :: proc(^context, ^glyph) ---

	/**
	* \brief Converts a unicode rune into UTF-8 and copies the result
	* into an internal text buffer.
	*
	* \details
	* \note Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_unicode(struct nk_context*, nk_rune rune);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] rune    | UTF-32 unicode codepoint
	*/
	input_unicode :: proc(^context, rune) ---

	/**
	* \brief End the input mirroring process by resetting mouse grabbing
	* state to ensure the mouse cursor is not grabbed indefinitely.
	*
	* \details
	* ```c
	* void nk_input_end(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	*/
	input_end :: proc(^context) ---
}

convert_result :: enum u32 {
	SUCCESS             = 0,
	INVALID_PARAM       = 1,
	COMMAND_BUFFER_FULL = 2,
	VERTEX_BUFFER_FULL  = 4,
	ELEMENT_BUFFER_FULL = 8,
}

draw_null_texture :: struct {
	texture: handle, /**!< texture handle to a texture with a white pixel */
	uv:      vec2,   /**!< coordinates to a white pixel in the texture  */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/**
	* \brief Returns a draw command list iterator to iterate all draw
	* commands accumulated over one frame.
	*
	* \details
	* ```c
	* const struct nk_command* nk__begin(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | must point to an previously initialized `nk_context` struct at the end of a frame
	*
	* \returns draw command pointer pointing to the first command inside the draw command list
	*/
	_begin :: proc(^context) -> ^command ---

	/**
	* \brief Returns draw command pointer pointing to the next command inside the draw command list
	*
	* \details
	* ```c
	* const struct nk_command* nk__next(struct nk_context*, const struct nk_command*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct at the end of a frame
	* \param[in] cmd     | Must point to an previously a draw command either returned by `nk__begin` or `nk__next`
	*
	* \returns draw command pointer pointing to the next command inside the draw command list
	*/
	_next :: proc(^context, ^command) -> ^command ---
}

panel_flag :: enum u32 {
	BORDER           = 0,
	MOVABLE          = 1,
	SCALABLE         = 2,
	CLOSABLE         = 3,
	MINIMIZABLE      = 4,
	NO_SCROLLBAR     = 5,
	TITLE            = 6,
	SCROLL_AUTO_HIDE = 7,
	BACKGROUND       = 8,
	SCALE_LEFT       = 9,
	NO_INPUT         = 10,
}

/* =============================================================================
*
*                                  WINDOW
*
* =============================================================================*/
/**
* \page Window
* Windows are the main persistent state used inside nuklear and are life time
* controlled by simply "retouching" (i.e.\ calling) each window each frame.
* All widgets inside nuklear can only be added inside the function pair `nk_begin_xxx`
* and `nk_end`. Calling any widgets outside these two functions will result in an
* assert in debug or no state change in release mode.<br /><br />
*
* Each window holds frame persistent state like position, size, flags, state tables,
* and some garbage collected internal persistent widget state. Each window
* is linked into a window stack list which determines the drawing and overlapping
* order. The topmost window thereby is the currently active window.<br /><br />
*
* To change window position inside the stack occurs either automatically by
* user input by being clicked on or programmatically by calling `nk_window_set_focus`.
* Windows by default are visible unless explicitly being defined with flag
* `NK_WINDOW_HIDDEN`, the user clicked the close button on windows with flag
* `NK_WINDOW_CLOSABLE` or if a window was explicitly hidden by calling
* `nk_window_show`. To explicitly close and destroy a window call `nk_window_close`.<br /><br />
*
* # Usage
* To create and keep a window you have to call one of the two `nk_begin_xxx`
* functions to start window declarations and `nk_end` at the end. Furthermore it
* is recommended to check the return value of `nk_begin_xxx` and only process
* widgets inside the window if the value is not 0. Either way you have to call
* `nk_end` at the end of window declarations. Furthermore, do not attempt to
* nest `nk_begin_xxx` calls which will hopefully result in an assert or if not
* in a segmentation fault.
*
* ```c
* if (nk_begin_xxx(...) {
*     // [... widgets ...]
* }
* nk_end(ctx);
* ```
*
* In the grand concept window and widget declarations need to occur after input
* handling and before drawing to screen. Not doing so can result in higher
* latency or at worst invalid behavior. Furthermore make sure that `nk_clear`
* is called at the end of the frame. While nuklear's default platform backends
* already call `nk_clear` for you if you write your own backend not calling
* `nk_clear` can cause asserts or even worse undefined behavior.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     Event evt;
*     nk_input_begin(&ctx);
*     while (GetEvent(&evt)) {
*         if (evt.type == MOUSE_MOVE)
*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*         else if (evt.type == [...]) {
*             nk_input_xxx(...);
*         }
*     }
*     nk_input_end(&ctx);
*
*     if (nk_begin_xxx(...) {
*         //[...]
*     }
*     nk_end(ctx);
*
*     const struct nk_command *cmd = 0;
*     nk_foreach(cmd, &ctx) {
*     case NK_COMMAND_LINE:
*         your_draw_line_function(...)
*         break;
*     case NK_COMMAND_RECT
*         your_draw_rect_function(...)
*         break;
*     case //...:
*         //[...]
*     }
*     nk_clear(&ctx);
* }
* nk_free(&ctx);
* ```
*
* # Reference
* Function                                 | Description
* -----------------------------------------|----------------------------------------
* \ref nk_begin                            | Starts a new window; needs to be called every frame for every window (unless hidden) or otherwise the window gets removed
* \ref nk_begin_titled                     | Extended window start with separated title and identifier to allow multiple windows with same name but not title
* \ref nk_end                              | Needs to be called at the end of the window building process to process scaling, scrollbars and general cleanup
*
* Function                                 | Description
* -----------------------------------------|----------------------------------------
* \ref nk_window_find                      | Finds and returns the window with give name
* \ref nk_window_get_bounds                | Returns a rectangle with screen position and size of the currently processed window.
* \ref nk_window_get_position              | Returns the position of the currently processed window
* \ref nk_window_get_size                  | Returns the size with width and height of the currently processed window
* \ref nk_window_get_width                 | Returns the width of the currently processed window
* \ref nk_window_get_height                | Returns the height of the currently processed window
* \ref nk_window_get_panel                 | Returns the underlying panel which contains all processing state of the current window
* \ref nk_window_get_content_region        | Returns the position and size of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_min    | Returns the upper rectangle position of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_max    | Returns the upper rectangle position of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_size   | Returns the size of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_canvas                | Returns the draw command buffer. Can be used to draw custom widgets
* \ref nk_window_get_scroll                | Gets the scroll offset of the current window
* \ref nk_window_has_focus                 | Returns if the currently processed window is currently active
* \ref nk_window_is_collapsed              | Returns if the window with given name is currently minimized/collapsed
* \ref nk_window_is_closed                 | Returns if the currently processed window was closed
* \ref nk_window_is_hidden                 | Returns if the currently processed window was hidden
* \ref nk_window_is_active                 | Same as nk_window_has_focus for some reason
* \ref nk_window_is_hovered                | Returns if the currently processed window is currently being hovered by mouse
* \ref nk_window_is_any_hovered            | Return if any window currently hovered
* \ref nk_item_is_any_active               | Returns if any window or widgets is currently hovered or active
*
* Function                                 | Description
* -----------------------------------------|----------------------------------------
* \ref nk_window_set_bounds                | Updates position and size of the currently processed window
* \ref nk_window_set_position              | Updates position of the currently process window
* \ref nk_window_set_size                  | Updates the size of the currently processed window
* \ref nk_window_set_focus                 | Set the currently processed window as active window
* \ref nk_window_set_scroll                | Sets the scroll offset of the current window
*
* Function                                 | Description
* -----------------------------------------|----------------------------------------
* \ref nk_window_close                     | Closes the window with given window name which deletes the window at the end of the frame
* \ref nk_window_collapse                  | Collapses the window with given window name
* \ref nk_window_collapse_if               | Collapses the window with given window name if the given condition was met
* \ref nk_window_show                      | Hides a visible or reshows a hidden window
* \ref nk_window_show_if                   | Hides/shows a window depending on condition

* # nk_panel_flags
* Flag                        | Description
* ----------------------------|----------------------------------------
* NK_WINDOW_BORDER            | Draws a border around the window to visually separate window from the background
* NK_WINDOW_MOVABLE           | The movable flag indicates that a window can be moved by user input or by dragging the window header
* NK_WINDOW_SCALABLE          | The scalable flag indicates that a window can be scaled by user input by dragging a scaler icon at the button of the window
* NK_WINDOW_CLOSABLE          | Adds a closable icon into the header
* NK_WINDOW_MINIMIZABLE       | Adds a minimize icon into the header
* NK_WINDOW_NO_SCROLLBAR      | Removes the scrollbar from the window
* NK_WINDOW_TITLE             | Forces a header at the top at the window showing the title
* NK_WINDOW_SCROLL_AUTO_HIDE  | Automatically hides the window scrollbar if no user interaction: also requires delta time in `nk_context` to be set each frame
* NK_WINDOW_BACKGROUND        | Always keep window in the background
* NK_WINDOW_SCALE_LEFT        | Puts window scaler in the left-bottom corner instead right-bottom
* NK_WINDOW_NO_INPUT          | Prevents window of scaling, moving or getting focus
*
* # nk_collapse_states
* State           | Description
* ----------------|-----------------------------------------------------------
* NK_MINIMIZED| UI section is collapsed and not visible until maximized
* NK_MAXIMIZED| UI section is extended and visible until minimized
*/
panel_flags :: bit_set[panel_flag; u32]

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/**
	* # # nk_begin
	* Starts a new window; needs to be called every frame for every
	* window (unless hidden) or otherwise the window gets removed
	*
	* ```c
	* nk_bool nk_begin(struct nk_context *ctx, const char *title, struct nk_rect bounds, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] title   | Window title and identifier. Needs to be persistent over frames to identify the window
	* \param[in] bounds  | Initial position and window size. However if you do not define `NK_WINDOW_SCALABLE` or `NK_WINDOW_MOVABLE` you can set window position and size every frame
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different window behaviors
	*
	* \returns `true(1)` if the window can be filled up with widgets from this point
	* until `nk_end` or `false(0)` otherwise for example if minimized
	
	*/
	begin :: proc(ctx: ^context, title: cstring, bounds: rect, flags: panel_flags) -> bool ---

	/**
	* # # nk_begin_titled
	* Extended window start with separated title and identifier to allow multiple
	* windows with same title but not name
	*
	* ```c
	* nk_bool nk_begin_titled(struct nk_context *ctx, const char *name, const char *title, struct nk_rect bounds, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Window identifier. Needs to be persistent over frames to identify the window
	* \param[in] title   | Window title displayed inside header if flag `NK_WINDOW_TITLE` or either `NK_WINDOW_CLOSABLE` or `NK_WINDOW_MINIMIZED` was set
	* \param[in] bounds  | Initial position and window size. However if you do not define `NK_WINDOW_SCALABLE` or `NK_WINDOW_MOVABLE` you can set window position and size every frame
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different window behaviors
	*
	* \returns `true(1)` if the window can be filled up with widgets from this point
	* until `nk_end` or `false(0)` otherwise for example if minimized
	
	*/
	begin_titled :: proc(ctx: ^context, name: cstring, title: cstring, bounds: rect, flags: panel_flags) -> bool ---

	/**
	* # # nk_end
	* Needs to be called at the end of the window building process to process scaling, scrollbars and general cleanup.
	* All widget calls after this functions will result in asserts or no state changes
	*
	* ```c
	* void nk_end(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	
	*/
	end :: proc(ctx: ^context) ---

	/**
	* # # nk_window_find
	* Finds and returns a window from passed name
	*
	* ```c
	* struct nk_window *nk_window_find(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Window identifier
	*
	* \returns a `nk_window` struct pointing to the identified window or NULL if
	* no window with the given name was found
	*/
	window_find :: proc(ctx: ^context, name: cstring) -> ^window ---

	/**
	* # # nk_window_get_bounds
	* \returns a rectangle with screen position and size of the currently processed window
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* struct nk_rect nk_window_get_bounds(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_rect` struct with window upper left window position and size
	
	*/
	window_get_bounds :: proc(ctx: ^context) -> rect ---

	/**
	* # # nk_window_get_position
	* \returns the position of the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* struct nk_vec2 nk_window_get_position(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_vec2` struct with window upper left position
	
	*/
	window_get_position :: proc(ctx: ^context) -> vec2 ---

	/**
	* # # nk_window_get_size
	* \returns the size with width and height of the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* struct nk_vec2 nk_window_get_size(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_vec2` struct with window width and height
	
	*/
	window_get_size :: proc(ctx: ^context) -> vec2 ---

	/**
	* nk_window_get_width
	* \returns the width of the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* float nk_window_get_width(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns the current window width
	*/
	window_get_width :: proc(ctx: ^context) -> f32 ---

	/**
	* # # nk_window_get_height
	* \returns the height of the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* float nk_window_get_height(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns the current window height
	
	*/
	window_get_height :: proc(ctx: ^context) -> f32 ---

	/**
	* # # nk_window_get_panel
	* \returns the underlying panel which contains all processing state of the current window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* \warning Do not keep the returned panel pointer around, it is only valid until `nk_end`.
	*
	* ```c
	* struct nk_panel* nk_window_get_panel(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a pointer to window internal `nk_panel` state.
	
	*/
	window_get_panel :: proc(ctx: ^context) -> ^panel ---

	/**
	* # # nk_window_get_content_region
	* \returns the position and size of the currently visible and non-clipped space
	* inside the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_rect nk_window_get_content_region(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_rect` struct with screen position and size (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	window_get_content_region :: proc(ctx: ^context) -> rect ---

	/**
	* # # nk_window_get_content_region_min
	* \returns the upper left position of the currently visible and non-clipped
	* space inside the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_min(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* returns `nk_vec2` struct with  upper left screen position (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	window_get_content_region_min :: proc(ctx: ^context) -> vec2 ---

	/**
	* # # nk_window_get_content_region_max
	* \returns the lower right screen position of the currently visible and
	* non-clipped space inside the currently processed window.
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_max(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_vec2` struct with lower right screen position (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	window_get_content_region_max :: proc(ctx: ^context) -> vec2 ---

	/**
	* # # nk_window_get_content_region_size
	* \returns the size of the currently visible and non-clipped space inside the
	* currently processed window
	*
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_size(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_vec2` struct with size the visible space inside the current window
	
	*/
	window_get_content_region_size :: proc(ctx: ^context) -> vec2 ---

	/**
	* # # nk_window_get_canvas
	* \returns the draw command buffer. Can be used to draw custom widgets
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	* \warning Do not keep the returned command buffer pointer around it is only valid until `nk_end`
	*
	* ```c
	* struct nk_command_buffer* nk_window_get_canvas(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a pointer to window internal `nk_command_buffer` struct used as
	* drawing canvas. Can be used to do custom drawing.
	*/
	window_get_canvas :: proc(ctx: ^context) -> ^command_buffer ---

	/**
	* # # nk_window_get_scroll
	* Gets the scroll offset for the current window
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* void nk_window_get_scroll(struct nk_context *ctx, nk_uint *offset_x, nk_uint *offset_y);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] offset_x | A pointer to the x offset output (or NULL to ignore)
	* \param[in] offset_y | A pointer to the y offset output (or NULL to ignore)
	
	*/
	window_get_scroll :: proc(ctx: ^context, offset_x: ^u32, offset_y: ^u32) ---

	/**
	* # # nk_window_has_focus
	* \returns if the currently processed window is currently active
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* nk_bool nk_window_has_focus(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `false(0)` if current window is not active or `true(1)` if it is
	
	*/
	window_has_focus :: proc(ctx: ^context) -> bool ---

	/**
	* # # nk_window_is_hovered
	* Return if the current window is being hovered
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`.
	*
	* ```c
	* nk_bool nk_window_is_hovered(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if current window is hovered or `false(0)` otherwise
	
	*/
	window_is_hovered :: proc(ctx: ^context) -> bool ---

	/**
	* # # nk_window_is_collapsed
	* \returns if the window with given name is currently minimized/collapsed
	* ```c
	* nk_bool nk_window_is_collapsed(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is collapsed
	*
	* \returns `true(1)` if current window is minimized and `false(0)` if window not
	* found or is not minimized
	
	*/
	window_is_collapsed :: proc(ctx: ^context, name: cstring) -> bool ---

	/**
	* # # nk_window_is_closed
	* \returns if the window with given name was closed by calling `nk_close`
	* ```c
	* nk_bool nk_window_is_closed(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is closed
	*
	* \returns `true(1)` if current window was closed or `false(0)` window not found or not closed
	
	*/
	window_is_closed :: proc(ctx: ^context, name: cstring) -> bool ---

	/**
	* # # nk_window_is_hidden
	* \returns if the window with given name is hidden
	* ```c
	* nk_bool nk_window_is_hidden(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is hidden
	*
	* \returns `true(1)` if current window is hidden or `false(0)` window not found or visible
	
	*/
	window_is_hidden :: proc(ctx: ^context, name: cstring) -> bool ---

	/**
	* # # nk_window_is_active
	* Same as nk_window_has_focus for some reason
	* ```c
	* nk_bool nk_window_is_active(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is active
	*
	* \returns `true(1)` if current window is active or `false(0)` window not found or not active
	*/
	window_is_active :: proc(ctx: ^context, name: cstring) -> bool ---

	/**
	* # # nk_window_is_any_hovered
	* \returns if the any window is being hovered
	* ```c
	* nk_bool nk_window_is_any_hovered(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if any window is hovered or `false(0)` otherwise
	*/
	window_is_any_hovered :: proc(ctx: ^context) -> bool ---

	/**
	* # # nk_item_is_any_active
	* \returns if the any window is being hovered or any widget is currently active.
	* Can be used to decide if input should be processed by UI or your specific input handling.
	* Example could be UI and 3D camera to move inside a 3D space.
	* ```c
	* nk_bool nk_item_is_any_active(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if any window is hovered or any item is active or `false(0)` otherwise
	
	*/
	item_is_any_active :: proc(ctx: ^context) -> bool ---

	/**
	* # # nk_window_set_bounds
	* Updates position and size of window with passed in name
	* ```c
	* void nk_window_set_bounds(struct nk_context*, const char *name, struct nk_rect bounds);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both position and size
	* \param[in] bounds  | Must point to a `nk_rect` struct with the new position and size
	
	*/
	window_set_bounds :: proc(ctx: ^context, name: cstring, bounds: rect) ---

	/**
	* # # nk_window_set_position
	* Updates position of window with passed name
	* ```c
	* void nk_window_set_position(struct nk_context*, const char *name, struct nk_vec2 pos);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both position
	* \param[in] pos     | Must point to a `nk_vec2` struct with the new position
	
	*/
	window_set_position :: proc(ctx: ^context, name: cstring, pos: vec2) ---

	/**
	* # # nk_window_set_size
	* Updates size of window with passed in name
	* ```c
	* void nk_window_set_size(struct nk_context*, const char *name, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both window size
	* \param[in] size    | Must point to a `nk_vec2` struct with new window size
	
	*/
	window_set_size :: proc(ctx: ^context, name: cstring, size: vec2) ---

	/**
	* # # nk_window_set_focus
	* Sets the window with given name as active
	* ```c
	* void nk_window_set_focus(struct nk_context*, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to set focus on
	
	*/
	window_set_focus :: proc(ctx: ^context, name: cstring) ---

	/**
	* # # nk_window_set_scroll
	* Sets the scroll offset for the current window
	* \warning Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* void nk_window_set_scroll(struct nk_context *ctx, nk_uint offset_x, nk_uint offset_y);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] offset_x | The x offset to scroll to
	* \param[in] offset_y | The y offset to scroll to
	
	*/
	window_set_scroll :: proc(ctx: ^context, offset_x: u32, offset_y: u32) ---

	/**
	* # # nk_window_close
	* Closes a window and marks it for being freed at the end of the frame
	* ```c
	* void nk_window_close(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to close
	
	*/
	window_close :: proc(ctx: ^context, name: cstring) ---

	/**
	* # # nk_window_collapse
	* Updates collapse state of a window with given name
	* ```c
	* void nk_window_collapse(struct nk_context*, const char *name, enum nk_collapse_states state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to close
	* \param[in] state   | value out of nk_collapse_states section
	
	*/
	window_collapse :: proc(ctx: ^context, name: cstring, state: collapse_states) ---

	/**
	* # # nk_window_collapse_if
	* Updates collapse state of a window with given name if given condition is met
	* ```c
	* void nk_window_collapse_if(struct nk_context*, const char *name, enum nk_collapse_states, int cond);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either collapse or maximize
	* \param[in] state   | value out of nk_collapse_states section the window should be put into
	* \param[in] cond    | condition that has to be met to actually commit the collapse state change
	
	*/
	window_collapse_if :: proc(ctx: ^context, name: cstring, state: collapse_states, cond: i32) ---

	/**
	* # # nk_window_show
	* updates visibility state of a window with given name
	* ```c
	* void nk_window_show(struct nk_context*, const char *name, enum nk_show_states);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either collapse or maximize
	* \param[in] state   | state with either visible or hidden to modify the window with
	*/
	window_show :: proc(ctx: ^context, name: cstring, state: show_states) ---

	/**
	* # # nk_window_show_if
	* Updates visibility state of a window with given name if a given condition is met
	* ```c
	* void nk_window_show_if(struct nk_context*, const char *name, enum nk_show_states, int cond);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either hide or show
	* \param[in] state   | state with either visible or hidden to modify the window with
	* \param[in] cond    | condition that has to be met to actually commit the visibility state change
	
	*/
	window_show_if :: proc(ctx: ^context, name: cstring, state: show_states, cond: i32) ---

	/**
	* # # nk_window_show_if
	* Line for visual separation. Draws a line with thickness determined by the current row height.
	* ```c
	* void nk_rule_horizontal(struct nk_context *ctx, struct nk_color color, nk_bool rounding)
	* ```
	*
	* Parameter       | Description
	* ----------------|-------------------------------------------------------
	* \param[in] ctx         | Must point to an previously initialized `nk_context` struct
	* \param[in] color       | Color of the horizontal line
	* \param[in] rounding    | Whether or not to make the line round
	*/
	rule_horizontal :: proc(ctx: ^context, color: color, rounding: bool) ---
}

widget_align :: enum u32 {
	LEFT     = 0,
	CENTERED = 1,
	RIGHT    = 2,
	TOP      = 3,
	MIDDLE   = 4,
	BOTTOM   = 5,
}

/* =============================================================================
*
*                                  LAYOUT
*
* =============================================================================*/
/**
* \page Layouting
* Layouting in general describes placing widget inside a window with position and size.
* While in this particular implementation there are five different APIs for layouting
* each with different trade offs between control and ease of use. <br /><br />
*
* All layouting methods in this library are based around the concept of a row.
* A row has a height the window content grows by and a number of columns and each
* layouting method specifies how each widget is placed inside the row.
* After a row has been allocated by calling a layouting functions and then
* filled with widgets will advance an internal pointer over the allocated row. <br /><br />
*
* To actually define a layout you just call the appropriate layouting function
* and each subsequent widget call will place the widget as specified. Important
* here is that if you define more widgets then columns defined inside the layout
* functions it will allocate the next row without you having to make another layouting call. <br /><br />
*
* Biggest limitation with using all these APIs outside the `nk_layout_space_xxx` API
* is that you have to define the row height for each. However the row height
* often depends on the height of the font. <br /><br />
*
* To fix that internally nuklear uses a minimum row height that is set to the
* height plus padding of currently active font and overwrites the row height
* value if zero. <br /><br />
*
* If you manually want to change the minimum row height then
* use nk_layout_set_min_row_height, and use nk_layout_reset_min_row_height to
* reset it back to be derived from font height. <br /><br />
*
* Also if you change the font in nuklear it will automatically change the minimum
* row height for you. This means if you change the font but still want
* a minimum row height smaller than the font you have to repush your value. <br /><br />
*
* For actually more advanced UI I would even recommend using the `nk_layout_space_xxx`
* layouting method in combination with a cassowary constraint solver (there are
* some versions on github with permissive license model) to take over all control over widget
* layouting yourself. However for quick and dirty layouting using all the other layouting
* functions should be fine.
*
* # Usage
* 1. __nk_layout_row_dynamic__<br /><br />
*    The easiest layouting function is `nk_layout_row_dynamic`. It provides each
*    widgets with same horizontal space inside the row and dynamically grows
*    if the owning window grows in width. So the number of columns dictates
*    the size of each widget dynamically by formula:
*
*    ```c
*    widget_width = (window_width - padding - spacing) * (1/column_count)
*    ```
*
*    Just like all other layouting APIs if you define more widget than columns this
*    library will allocate a new row and keep all layouting parameters previously
*    defined.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // first row with height: 30 composed of two widgets
*        nk_layout_row_dynamic(&ctx, 30, 2);
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // second row with same parameter as defined above
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // third row uses 0 for height which will use auto layouting
*        nk_layout_row_dynamic(&ctx, 0, 2);
*        nk_widget(...);
*        nk_widget(...);
*    }
*    nk_end(...);
*    ```
*
* 2. __nk_layout_row_static__<br /><br />
*    Another easy layouting function is `nk_layout_row_static`. It provides each
*    widget with same horizontal pixel width inside the row and does not grow
*    if the owning window scales smaller or bigger.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // first row with height: 30 composed of two widgets with width: 80
*        nk_layout_row_static(&ctx, 30, 80, 2);
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // second row with same parameter as defined above
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // third row uses 0 for height which will use auto layouting
*        nk_layout_row_static(&ctx, 0, 80, 2);
*        nk_widget(...);
*        nk_widget(...);
*    }
*    nk_end(...);
*    ```
*
* 3. __nk_layout_row_xxx__<br /><br />
*    A little bit more advanced layouting API are functions `nk_layout_row_begin`,
*    `nk_layout_row_push` and `nk_layout_row_end`. They allow to directly
*    specify each column pixel or window ratio in a row. It supports either
*    directly setting per column pixel width or widget window ratio but not
*    both. Furthermore it is a immediate mode API so each value is directly
*    pushed before calling a widget. Therefore the layout is not automatically
*    repeating like the last two layouting functions.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // first row with height: 25 composed of two widgets with width 60 and 40
*        nk_layout_row_begin(ctx, NK_STATIC, 25, 2);
*        nk_layout_row_push(ctx, 60);
*        nk_widget(...);
*        nk_layout_row_push(ctx, 40);
*        nk_widget(...);
*        nk_layout_row_end(ctx);
*        //
*        // second row with height: 25 composed of two widgets with window ratio 0.25 and 0.75
*        nk_layout_row_begin(ctx, NK_DYNAMIC, 25, 2);
*        nk_layout_row_push(ctx, 0.25f);
*        nk_widget(...);
*        nk_layout_row_push(ctx, 0.75f);
*        nk_widget(...);
*        nk_layout_row_end(ctx);
*        //
*        // third row with auto generated height: composed of two widgets with window ratio 0.25 and 0.75
*        nk_layout_row_begin(ctx, NK_DYNAMIC, 0, 2);
*        nk_layout_row_push(ctx, 0.25f);
*        nk_widget(...);
*        nk_layout_row_push(ctx, 0.75f);
*        nk_widget(...);
*        nk_layout_row_end(ctx);
*    }
*    nk_end(...);
*    ```
*
* 4. __nk_layout_row__<br /><br />
*    The array counterpart to API nk_layout_row_xxx is the single nk_layout_row
*    functions. Instead of pushing either pixel or window ratio for every widget
*    it allows to define it by array. The trade of for less control is that
*    `nk_layout_row` is automatically repeating. Otherwise the behavior is the
*    same.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // two rows with height: 30 composed of two widgets with width 60 and 40
*        const float ratio[] = {60,40};
*        nk_layout_row(ctx, NK_STATIC, 30, 2, ratio);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // two rows with height: 30 composed of two widgets with window ratio 0.25 and 0.75
*        const float ratio[] = {0.25, 0.75};
*        nk_layout_row(ctx, NK_DYNAMIC, 30, 2, ratio);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*        //
*        // two rows with auto generated height composed of two widgets with window ratio 0.25 and 0.75
*        const float ratio[] = {0.25, 0.75};
*        nk_layout_row(ctx, NK_DYNAMIC, 30, 2, ratio);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*    }
*    nk_end(...);
*    ```
*
* 5. __nk_layout_row_template_xxx__<br /><br />
*    The most complex and second most flexible API is a simplified flexbox version without
*    line wrapping and weights for dynamic widgets. It is an immediate mode API but
*    unlike `nk_layout_row_xxx` it has auto repeat behavior and needs to be called
*    before calling the templated widgets.
*    The row template layout has three different per widget size specifier. The first
*    one is the `nk_layout_row_template_push_static`  with fixed widget pixel width.
*    They do not grow if the row grows and will always stay the same.
*    The second size specifier is `nk_layout_row_template_push_variable`
*    which defines a minimum widget size but it also can grow if more space is available
*    not taken by other widgets.
*    Finally there are dynamic widgets with `nk_layout_row_template_push_dynamic`
*    which are completely flexible and unlike variable widgets can even shrink
*    to zero if not enough space is provided.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // two rows with height: 30 composed of three widgets
*        nk_layout_row_template_begin(ctx, 30);
*        nk_layout_row_template_push_dynamic(ctx);
*        nk_layout_row_template_push_variable(ctx, 80);
*        nk_layout_row_template_push_static(ctx, 80);
*        nk_layout_row_template_end(ctx);
*        //
*        // first row
*        nk_widget(...); // dynamic widget can go to zero if not enough space
*        nk_widget(...); // variable widget with min 80 pixel but can grow bigger if enough space
*        nk_widget(...); // static widget with fixed 80 pixel width
*        //
*        // second row same layout
*        nk_widget(...);
*        nk_widget(...);
*        nk_widget(...);
*    }
*    nk_end(...);
*    ```
*
* 6. __nk_layout_space_xxx__<br /><br />
*    Finally the most flexible API directly allows you to place widgets inside the
*    window. The space layout API is an immediate mode API which does not support
*    row auto repeat and directly sets position and size of a widget. Position
*    and size hereby can be either specified as ratio of allocated space or
*    allocated space local position and pixel size. Since this API is quite
*    powerful there are a number of utility functions to get the available space
*    and convert between local allocated space and screen space.
*
*    ```c
*    if (nk_begin_xxx(...) {
*        // static row with height: 500 (you can set column count to INT_MAX if you don't want to be bothered)
*        nk_layout_space_begin(ctx, NK_STATIC, 500, INT_MAX);
*        nk_layout_space_push(ctx, nk_rect(0,0,150,200));
*        nk_widget(...);
*        nk_layout_space_push(ctx, nk_rect(200,200,100,200));
*        nk_widget(...);
*        nk_layout_space_end(ctx);
*        //
*        // dynamic row with height: 500 (you can set column count to INT_MAX if you don't want to be bothered)
*        nk_layout_space_begin(ctx, NK_DYNAMIC, 500, INT_MAX);
*        nk_layout_space_push(ctx, nk_rect(0.5,0.5,0.1,0.1));
*        nk_widget(...);
*        nk_layout_space_push(ctx, nk_rect(0.7,0.6,0.1,0.1));
*        nk_widget(...);
*    }
*    nk_end(...);
*    ```
*
* # Reference
* Function                                     | Description
* ---------------------------------------------|------------------------------------
* \ref nk_layout_set_min_row_height            | Set the currently used minimum row height to a specified value
* \ref nk_layout_reset_min_row_height          | Resets the currently used minimum row height to font height
* \ref nk_layout_widget_bounds                 | Calculates current width a static layout row can fit inside a window
* \ref nk_layout_ratio_from_pixel              | Utility functions to calculate window ratio from pixel size
* \ref nk_layout_row_dynamic                   | Current layout is divided into n same sized growing columns
* \ref nk_layout_row_static                    | Current layout is divided into n same fixed sized columns
* \ref nk_layout_row_begin                     | Starts a new row with given height and number of columns
* \ref nk_layout_row_push                      | Pushes another column with given size or window ratio
* \ref nk_layout_row_end                       | Finished previously started row
* \ref nk_layout_row                           | Specifies row columns in array as either window ratio or size
* \ref nk_layout_row_template_begin            | Begins the row template declaration
* \ref nk_layout_row_template_push_dynamic     | Adds a dynamic column that dynamically grows and can go to zero if not enough space
* \ref nk_layout_row_template_push_variable    | Adds a variable column that dynamically grows but does not shrink below specified pixel width
* \ref nk_layout_row_template_push_static      | Adds a static column that does not grow and will always have the same size
* \ref nk_layout_row_template_end              | Marks the end of the row template
* \ref nk_layout_space_begin                   | Begins a new layouting space that allows to specify each widgets position and size
* \ref nk_layout_space_push                    | Pushes position and size of the next widget in own coordinate space either as pixel or ratio
* \ref nk_layout_space_end                     | Marks the end of the layouting space
* \ref nk_layout_space_bounds                  | Callable after nk_layout_space_begin and returns total space allocated
* \ref nk_layout_space_to_screen               | Converts vector from nk_layout_space coordinate space into screen space
* \ref nk_layout_space_to_local                | Converts vector from screen space into nk_layout_space coordinates
* \ref nk_layout_space_rect_to_screen          | Converts rectangle from nk_layout_space coordinate space into screen space
* \ref nk_layout_space_rect_to_local           | Converts rectangle from screen space into nk_layout_space coordinates
*/
widget_alignment :: bit_set[widget_align; u32]

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/**
	* Sets the currently used minimum row height.
	* \warning The passed height needs to include both your preferred row height
	*     as well as padding. No internal padding is added.
	*
	* ```c
	* void nk_layout_set_min_row_height(struct nk_context*, float height);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | New minimum row height to be used for auto generating the row height
	*/
	layout_set_min_row_height :: proc(_: ^context, height: f32) ---

	/**
	* Reset the currently used minimum row height back to `font_height + text_padding + padding`
	* ```c
	* void nk_layout_reset_min_row_height(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	layout_reset_min_row_height :: proc(^context) ---

	/**
	* \brief Returns the width of the next row allocate by one of the layouting functions
	*
	* \details
	* ```c
	* struct nk_rect nk_layout_widget_bounds(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*
	* \return `nk_rect` with both position and size of the next row
	*/
	layout_widget_bounds :: proc(ctx: ^context) -> rect ---

	/**
	* \brief Utility functions to calculate window ratio from pixel size
	*
	* \details
	* ```c
	* float nk_layout_ratio_from_pixel(struct nk_context*, float pixel_width);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] pixel   | Pixel_width to convert to window ratio
	*
	* \returns `nk_rect` with both position and size of the next row
	*/
	layout_ratio_from_pixel :: proc(ctx: ^context, pixel_width: f32) -> f32 ---

	/**
	* \brief Sets current row layout to share horizontal space
	* between @cols number of widgets evenly. Once called all subsequent widget
	* calls greater than @cols will allocate a new row with same layout.
	*
	* \details
	* ```c
	* void nk_layout_row_dynamic(struct nk_context *ctx, float height, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	layout_row_dynamic :: proc(ctx: ^context, height: f32, cols: i32) ---

	/**
	* \brief Sets current row layout to fill @cols number of widgets
	* in row with same @item_width horizontal size. Once called all subsequent widget
	* calls greater than @cols will allocate a new row with same layout.
	*
	* \details
	* ```c
	* void nk_layout_row_static(struct nk_context *ctx, float height, int item_width, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] width   | Holds pixel width of each widget in the row
	* \param[in] columns | Number of widget inside row
	*/
	layout_row_static :: proc(ctx: ^context, height: f32, item_width: i32, cols: i32) ---

	/**
	* \brief Starts a new dynamic or fixed row with given height and columns.
	*
	* \details
	* ```c
	* void nk_layout_row_begin(struct nk_context *ctx, enum nk_layout_format fmt, float row_height, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	layout_row_begin :: proc(ctx: ^context, fmt: layout_format, row_height: f32, cols: i32) ---

	/**
	* \breif Specifies either window ratio or width of a single column
	*
	* \details
	* ```c
	* void nk_layout_row_push(struct nk_context*, float value);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] value   | either a window ratio or fixed width depending on @fmt in previous `nk_layout_row_begin` call
	*/
	layout_row_push :: proc(_: ^context, value: f32) ---

	/**
	* \brief Finished previously started row
	*
	* \details
	* ```c
	* void nk_layout_row_end(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	layout_row_end :: proc(^context) ---

	/**
	* \brief Specifies row columns in array as either window ratio or size
	*
	* \details
	* ```c
	* void nk_layout_row(struct nk_context*, enum nk_layout_format, float height, int cols, const float *ratio);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | Either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	layout_row :: proc(_: ^context, _: layout_format, height: f32, cols: i32, ratio: ^f32) ---

	/**
	* # # nk_layout_row_template_begin
	* Begins the row template declaration
	* ```c
	* void nk_layout_row_template_begin(struct nk_context*, float row_height);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	*/
	layout_row_template_begin :: proc(_: ^context, row_height: f32) ---

	/**
	* # # nk_layout_row_template_push_dynamic
	* Adds a dynamic column that dynamically grows and can go to zero if not enough space
	* ```c
	* void nk_layout_row_template_push_dynamic(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	*/
	layout_row_template_push_dynamic :: proc(^context) ---

	/**
	* # # nk_layout_row_template_push_variable
	* Adds a variable column that dynamically grows but does not shrink below specified pixel width
	* ```c
	* void nk_layout_row_template_push_variable(struct nk_context*, float min_width);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] width   | Holds the minimum pixel width the next column must always be
	*/
	layout_row_template_push_variable :: proc(_: ^context, min_width: f32) ---

	/**
	* # # nk_layout_row_template_push_static
	* Adds a static column that does not grow and will always have the same size
	* ```c
	* void nk_layout_row_template_push_static(struct nk_context*, float width);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] width   | Holds the absolute pixel width value the next column must be
	*/
	layout_row_template_push_static :: proc(_: ^context, width: f32) ---

	/**
	* # # nk_layout_row_template_end
	* Marks the end of the row template
	* ```c
	* void nk_layout_row_template_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	layout_row_template_end :: proc(^context) ---

	/**
	* # # nk_layout_space_begin
	* Begins a new layouting space that allows to specify each widgets position and size.
	* ```c
	* void nk_layout_space_begin(struct nk_context*, enum nk_layout_format, float height, int widget_count);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | Either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widgets inside row
	*/
	layout_space_begin :: proc(_: ^context, _: layout_format, height: f32, widget_count: i32) ---

	/**
	* # # nk_layout_space_push
	* Pushes position and size of the next widget in own coordinate space either as pixel or ratio
	* ```c
	* void nk_layout_space_push(struct nk_context *ctx, struct nk_rect bounds);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Position and size in layout space local coordinates
	*/
	layout_space_push :: proc(_: ^context, bounds: rect) ---

	/**
	* # # nk_layout_space_end
	* Marks the end of the layout space
	* ```c
	* void nk_layout_space_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*/
	layout_space_end :: proc(^context) ---

	/**
	* # # nk_layout_space_bounds
	* Utility function to calculate total space allocated for `nk_layout_space`
	* ```c
	* struct nk_rect nk_layout_space_bounds(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*
	* \returns `nk_rect` holding the total space allocated
	*/
	layout_space_bounds :: proc(ctx: ^context) -> rect ---

	/**
	* # # nk_layout_space_to_screen
	* Converts vector from nk_layout_space coordinate space into screen space
	* ```c
	* struct nk_vec2 nk_layout_space_to_screen(struct nk_context*, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] vec     | Position to convert from layout space into screen coordinate space
	*
	* \returns transformed `nk_vec2` in screen space coordinates
	*/
	layout_space_to_screen :: proc(ctx: ^context, vec: vec2) -> vec2 ---

	/**
	* # # nk_layout_space_to_local
	* Converts vector from layout space into screen space
	* ```c
	* struct nk_vec2 nk_layout_space_to_local(struct nk_context*, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] vec     | Position to convert from screen space into layout coordinate space
	*
	* \returns transformed `nk_vec2` in layout space coordinates
	*/
	layout_space_to_local :: proc(ctx: ^context, vec: vec2) -> vec2 ---

	/**
	* # # nk_layout_space_rect_to_screen
	* Converts rectangle from screen space into layout space
	* ```c
	* struct nk_rect nk_layout_space_rect_to_screen(struct nk_context*, struct nk_rect);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Rectangle to convert from layout space into screen space
	*
	* \returns transformed `nk_rect` in screen space coordinates
	*/
	layout_space_rect_to_screen :: proc(ctx: ^context, bounds: rect) -> rect ---

	/**
	* # # nk_layout_space_rect_to_local
	* Converts rectangle from layout space into screen space
	* ```c
	* struct nk_rect nk_layout_space_rect_to_local(struct nk_context*, struct nk_rect);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Rectangle to convert from layout space into screen space
	*
	* \returns transformed `nk_rect` in layout space coordinates
	*/
	layout_space_rect_to_local :: proc(ctx: ^context, bounds: rect) -> rect ---

	/**
	* # # nk_spacer
	* Spacer is a dummy widget that consumes space as usual but doesn't draw anything
	* ```c
	* void nk_spacer(struct nk_context* );
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*
	*/
	spacer :: proc(ctx: ^context) ---

	/**
	* \brief Starts a new widget group. Requires a previous layouting function to specify a pos/size.
	* ```c
	* nk_bool nk_group_begin(struct nk_context*, const char *title, nk_flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] title   | Must be an unique identifier for this group that is also used for the group header
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different group behaviors
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	group_begin :: proc(_: ^context, title: cstring, _: panel_flags) -> bool ---

	/**
	* \brief Starts a new widget group. Requires a previous layouting function to specify a pos/size.
	* ```c
	* nk_bool nk_group_begin_titled(struct nk_context*, const char *name, const char *title, nk_flags);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] id      | Must be an unique identifier for this group
	* \param[in] title   | Group header title
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different group behaviors
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	group_begin_titled :: proc(_: ^context, name: cstring, title: cstring, _: panel_flags) -> bool ---

	/**
	* # # nk_group_end
	* Ends a widget group
	* ```c
	* void nk_group_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*/
	group_end :: proc(^context) ---

	/**
	* # # nk_group_scrolled_offset_begin
	* starts a new widget group. requires a previous layouting function to specify
	* a size. Does not keep track of scrollbar.
	* ```c
	* nk_bool nk_group_scrolled_offset_begin(struct nk_context*, nk_uint *x_offset, nk_uint *y_offset, const char *title, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] x_offset| Scrollbar x-offset to offset all widgets inside the group horizontally.
	* \param[in] y_offset| Scrollbar y-offset to offset all widgets inside the group vertically
	* \param[in] title   | Window unique group title used to both identify and display in the group header
	* \param[in] flags   | Window flags from the nk_panel_flags section
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	group_scrolled_offset_begin :: proc(_: ^context, x_offset: ^u32, y_offset: ^u32, title: cstring, flags: panel_flags) -> bool ---

	/**
	* # # nk_group_scrolled_begin
	* Starts a new widget group. requires a previous
	* layouting function to specify a size. Does not keep track of scrollbar.
	* ```c
	* nk_bool nk_group_scrolled_begin(struct nk_context*, struct nk_scroll *off, const char *title, nk_flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] off     | Both x- and y- scroll offset. Allows for manual scrollbar control
	* \param[in] title   | Window unique group title used to both identify and display in the group header
	* \param[in] flags   | Window flags from nk_panel_flags section
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	group_scrolled_begin :: proc(_: ^context, off: ^scroll, title: cstring, _: panel_flags) -> bool ---

	/**
	* # # nk_group_scrolled_end
	* Ends a widget group after calling nk_group_scrolled_offset_begin or nk_group_scrolled_begin.
	* ```c
	* void nk_group_scrolled_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*/
	group_scrolled_end :: proc(^context) ---

	/**
	* # # nk_group_get_scroll
	* Gets the scroll position of the given group.
	* ```c
	* void nk_group_get_scroll(struct nk_context*, const char *id, nk_uint *x_offset, nk_uint *y_offset);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] id       | The id of the group to get the scroll position of
	* \param[in] x_offset | A pointer to the x offset output (or NULL to ignore)
	* \param[in] y_offset | A pointer to the y offset output (or NULL to ignore)
	*/
	group_get_scroll :: proc(_: ^context, id: cstring, x_offset: ^u32, y_offset: ^u32) ---

	/**
	* # # nk_group_set_scroll
	* Sets the scroll position of the given group.
	* ```c
	* void nk_group_set_scroll(struct nk_context*, const char *id, nk_uint x_offset, nk_uint y_offset);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] id       | The id of the group to scroll
	* \param[in] x_offset | The x offset to scroll to
	* \param[in] y_offset | The y offset to scroll to
	*/
	group_set_scroll :: proc(_: ^context, id: cstring, x_offset: u32, y_offset: u32) ---

	/**
	* # # nk_tree_push_hashed
	* Start a collapsible UI section with internal state management with full
	* control over internal unique ID used to store state
	* ```c
	* nk_bool nk_tree_push_hashed(struct nk_context*, enum nk_tree_type, const char *title, enum nk_collapse_states initial_state, const char *hash, int len,int seed);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Initial tree state value out of nk_collapse_states
	* \param[in] hash    | Memory block or string to generate the ID from
	* \param[in] len     | Size of passed memory block or string in __hash__
	* \param[in] seed    | Seeding value if this function is called in a loop or default to `0`
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	tree_push_hashed :: proc(_: ^context, _: tree_type, title: cstring, initial_state: collapse_states, hash: cstring, len: i32, seed: i32) -> bool ---

	/**
	* # # nk_tree_image_push_hashed
	* Start a collapsible UI section with internal state management with full
	* control over internal unique ID used to store state
	* ```c
	* nk_bool nk_tree_image_push_hashed(struct nk_context*, enum nk_tree_type, struct nk_image, const char *title, enum nk_collapse_states initial_state, const char *hash, int len,int seed);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] img     | Image to display inside the header on the left of the label
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Initial tree state value out of nk_collapse_states
	* \param[in] hash    | Memory block or string to generate the ID from
	* \param[in] len     | Size of passed memory block or string in __hash__
	* \param[in] seed    | Seeding value if this function is called in a loop or default to `0`
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	tree_image_push_hashed :: proc(_: ^context, _: tree_type, _: image, title: cstring, initial_state: collapse_states, hash: cstring, len: i32, seed: i32) -> bool ---

	/**
	* # # nk_tree_pop
	* Ends a collapsabale UI section
	* ```c
	* void nk_tree_pop(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	*/
	tree_pop :: proc(^context) ---

	/**
	* # # nk_tree_state_push
	* Start a collapsible UI section with external state management
	* ```c
	* nk_bool nk_tree_state_push(struct nk_context*, enum nk_tree_type, const char *title, enum nk_collapse_states *state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Persistent state to update
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	tree_state_push :: proc(_: ^context, _: tree_type, title: cstring, state: ^collapse_states) -> bool ---

	/**
	* # # nk_tree_state_image_push
	* Start a collapsible UI section with image and label header and external state management
	* ```c
	* nk_bool nk_tree_state_image_push(struct nk_context*, enum nk_tree_type, struct nk_image, const char *title, enum nk_collapse_states *state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	* \param[in] img     | Image to display inside the header on the left of the label
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Persistent state to update
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	tree_state_image_push :: proc(_: ^context, _: tree_type, _: image, title: cstring, state: ^collapse_states) -> bool ---

	/**
	* # # nk_tree_state_pop
	* Ends a collapsabale UI section
	* ```c
	* void nk_tree_state_pop(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	*/
	tree_state_pop                 :: proc(^context) ---
	tree_element_push_hashed       :: proc(_: ^context, _: tree_type, title: cstring, initial_state: collapse_states, selected: ^bool, hash: cstring, len: i32, seed: i32) -> bool ---
	tree_element_image_push_hashed :: proc(_: ^context, _: tree_type, _: image, title: cstring, initial_state: collapse_states, selected: ^bool, hash: cstring, len: i32, seed: i32) -> bool ---
	tree_element_pop               :: proc(^context) ---
}

/* =============================================================================
*
*                                  LIST VIEW
*
* ============================================================================= */
list_view :: struct {
	/* public: */
	begin, end, count: i32,

	/* private: */
	total_height:   i32,
	ctx:            ^context,
	scroll_pointer: ^u32,
	scroll_value:   u32,
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	list_view_begin :: proc(_: ^context, out: ^list_view, id: cstring, _: panel_flags, row_height: i32, row_count: i32) -> bool ---
	list_view_end   :: proc(^list_view) ---
}

/* =============================================================================
*
*                                  WIDGET
*
* ============================================================================= */
widget_layout_states :: enum u32 {
	INVALID  = 0, /**< The widget cannot be seen and is completely out of view */
	VALID    = 1, /**< The widget is completely inside the window and can be updated and drawn */
	ROM      = 2, /**< The widget is partially visible and cannot be updated */
	DISABLED = 3, /**< The widget is manually disabled and acts like NK_WIDGET_ROM */
}

widget_states :: enum u32 {
	MODIFIED = 2,
	INACTIVE = 4,  /**!< widget is neither active nor hovered */
	ENTERED  = 8,  /**!< widget has been hovered on the current frame */
	HOVER    = 16, /**!< widget is being hovered */
	ACTIVED  = 32, /**!< widget is currently activated */
	LEFT     = 64, /**!< widget is from this frame on not hovered anymore */
	HOVERED  = 18, /**!< widget is being hovered */
	ACTIVE   = 34, /**!< widget is currently activated */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	widget                      :: proc(^rect, ^context) -> widget_layout_states ---
	widget_bounds               :: proc(^context) -> rect ---
	widget_position             :: proc(^context) -> vec2 ---
	widget_size                 :: proc(^context) -> vec2 ---
	widget_width                :: proc(^context) -> f32 ---
	widget_height               :: proc(^context) -> f32 ---
	widget_is_hovered           :: proc(^context) -> bool ---
	widget_is_mouse_clicked     :: proc(^context, buttons) -> bool ---
	widget_has_mouse_click_down :: proc(_: ^context, _: buttons, down: bool) -> bool ---
	spacing                     :: proc(_: ^context, cols: i32) ---
	widget_disable_begin        :: proc(ctx: ^context) ---
	widget_disable_end          :: proc(ctx: ^context) ---
}

text_align :: enum u32 {
	LEFT     = 0,
	CENTERED = 1,
	RIGHT    = 2,
	TOP      = 3,
	MIDDLE   = 4,
	BOTTOM   = 5,
}

/* =============================================================================
*
*                                  TEXT
*
* ============================================================================= */
text_alignment :: bit_set[text_align; u32]

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	text               :: proc(^context, cstring, i32, text_alignment) ---
	text_colored       :: proc(^context, cstring, i32, text_alignment, color) ---
	text_wrap          :: proc(^context, cstring, i32) ---
	text_wrap_colored  :: proc(^context, cstring, i32, color) ---
	label              :: proc(_: ^context, _: cstring, align: text_alignment) ---
	label_colored      :: proc(_: ^context, _: cstring, align: text_alignment, _: color) ---
	label_wrap         :: proc(^context, cstring) ---
	label_colored_wrap :: proc(^context, cstring, color) ---
	image_color        :: proc(^context, image, color) ---

	/* =============================================================================
	*
	*                                  BUTTON
	*
	* ============================================================================= */
	button_text                :: proc(_: ^context, title: cstring, len: i32) -> bool ---
	button_label               :: proc(_: ^context, title: cstring) -> bool ---
	button_color               :: proc(^context, color) -> bool ---
	button_symbol              :: proc(^context, symbol_type) -> bool ---
	button_image               :: proc(_: ^context, img: image) -> bool ---
	button_symbol_label        :: proc(_: ^context, _: symbol_type, _: cstring, text_alignment: text_alignment) -> bool ---
	button_symbol_text         :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	button_image_label         :: proc(_: ^context, img: image, _: cstring, text_alignment: text_alignment) -> bool ---
	button_image_text          :: proc(_: ^context, img: image, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	button_text_styled         :: proc(_: ^context, _: ^style_button, title: cstring, len: i32) -> bool ---
	button_label_styled        :: proc(_: ^context, _: ^style_button, title: cstring) -> bool ---
	button_symbol_styled       :: proc(^context, ^style_button, symbol_type) -> bool ---
	button_image_styled        :: proc(_: ^context, _: ^style_button, img: image) -> bool ---
	button_symbol_text_styled  :: proc(_: ^context, _: ^style_button, _: symbol_type, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	button_symbol_label_styled :: proc(ctx: ^context, style: ^style_button, symbol: symbol_type, title: cstring, align: text_alignment) -> bool ---
	button_image_label_styled  :: proc(_: ^context, _: ^style_button, img: image, _: cstring, text_alignment: text_alignment) -> bool ---
	button_image_text_styled   :: proc(_: ^context, _: ^style_button, img: image, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	button_set_behavior        :: proc(^context, button_behavior) ---
	button_push_behavior       :: proc(^context, button_behavior) -> bool ---
	button_pop_behavior        :: proc(^context) -> bool ---

	/* =============================================================================
	*
	*                                  CHECKBOX
	*
	* ============================================================================= */
	check_label          :: proc(_: ^context, _: cstring, active: bool) -> bool ---
	check_text           :: proc(_: ^context, _: cstring, _: i32, active: bool) -> bool ---
	check_text_align     :: proc(_: ^context, _: cstring, _: i32, active: bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	check_flags_label    :: proc(_: ^context, _: cstring, flags: u32, value: u32) -> u32 ---
	check_flags_text     :: proc(_: ^context, _: cstring, _: i32, flags: u32, value: u32) -> u32 ---
	checkbox_label       :: proc(_: ^context, _: cstring, active: ^bool) -> bool ---
	checkbox_label_align :: proc(ctx: ^context, label: cstring, active: ^bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	checkbox_text        :: proc(_: ^context, _: cstring, _: i32, active: ^bool) -> bool ---
	checkbox_text_align  :: proc(ctx: ^context, text: cstring, len: i32, active: ^bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	checkbox_flags_label :: proc(_: ^context, _: cstring, flags: ^u32, value: u32) -> bool ---
	checkbox_flags_text  :: proc(_: ^context, _: cstring, _: i32, flags: ^u32, value: u32) -> bool ---

	/* =============================================================================
	*
	*                                  RADIO BUTTON
	*
	* ============================================================================= */
	radio_label        :: proc(_: ^context, _: cstring, active: ^bool) -> bool ---
	radio_label_align  :: proc(ctx: ^context, label: cstring, active: ^bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	radio_text         :: proc(_: ^context, _: cstring, _: i32, active: ^bool) -> bool ---
	radio_text_align   :: proc(ctx: ^context, text: cstring, len: i32, active: ^bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	option_label       :: proc(_: ^context, _: cstring, active: bool) -> bool ---
	option_label_align :: proc(ctx: ^context, label: cstring, active: bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---
	option_text        :: proc(_: ^context, _: cstring, _: i32, active: bool) -> bool ---
	option_text_align  :: proc(ctx: ^context, text: cstring, len: i32, is_active: bool, widget_alignment: widget_alignment, text_alignment: text_alignment) -> bool ---

	/* =============================================================================
	*
	*                                  SELECTABLE
	*
	* ============================================================================= */
	selectable_label        :: proc(_: ^context, _: cstring, align: text_alignment, value: ^bool) -> bool ---
	selectable_text         :: proc(_: ^context, _: cstring, _: i32, align: text_alignment, value: ^bool) -> bool ---
	selectable_image_label  :: proc(_: ^context, _: image, _: cstring, align: text_alignment, value: ^bool) -> bool ---
	selectable_image_text   :: proc(_: ^context, _: image, _: cstring, _: i32, align: text_alignment, value: ^bool) -> bool ---
	selectable_symbol_label :: proc(_: ^context, _: symbol_type, _: cstring, align: text_alignment, value: ^bool) -> bool ---
	selectable_symbol_text  :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, align: text_alignment, value: ^bool) -> bool ---
	select_label            :: proc(_: ^context, _: cstring, align: text_alignment, value: bool) -> bool ---
	select_text             :: proc(_: ^context, _: cstring, _: i32, align: text_alignment, value: bool) -> bool ---
	select_image_label      :: proc(_: ^context, _: image, _: cstring, align: text_alignment, value: bool) -> bool ---
	select_image_text       :: proc(_: ^context, _: image, _: cstring, _: i32, align: text_alignment, value: bool) -> bool ---
	select_symbol_label     :: proc(_: ^context, _: symbol_type, _: cstring, align: text_alignment, value: bool) -> bool ---
	select_symbol_text      :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, align: text_alignment, value: bool) -> bool ---

	/* =============================================================================
	*
	*                                  SLIDER
	*
	* ============================================================================= */
	slide_float  :: proc(_: ^context, min: f32, val: f32, max: f32, step: f32) -> f32 ---
	slide_int    :: proc(_: ^context, min: i32, val: i32, max: i32, step: i32) -> i32 ---
	slider_float :: proc(_: ^context, min: f32, val: ^f32, max: f32, step: f32) -> bool ---
	slider_int   :: proc(_: ^context, min: i32, val: ^i32, max: i32, step: i32) -> bool ---

	/* =============================================================================
	*
	*                                   KNOB
	*
	* ============================================================================= */
	knob_float :: proc(_: ^context, min: f32, val: ^f32, max: f32, step: f32, zero_direction: heading, dead_zone_degrees: f32) -> bool ---
	knob_int   :: proc(_: ^context, min: i32, val: ^i32, max: i32, step: i32, zero_direction: heading, dead_zone_degrees: f32) -> bool ---

	/* =============================================================================
	*
	*                                  PROGRESSBAR
	*
	* ============================================================================= */
	progress :: proc(_: ^context, cur: ^uint, max: uint, modifyable: bool) -> bool ---
	prog     :: proc(_: ^context, cur: uint, max: uint, modifyable: bool) -> uint ---

	/* =============================================================================
	*
	*                                  COLOR PICKER
	*
	* ============================================================================= */
	color_picker :: proc(^context, colorf, color_format) -> colorf ---
	color_pick   :: proc(^context, ^colorf, color_format) -> bool ---

	/* =============================================================================
	*
	*                                  PROPERTIES
	*
	* =============================================================================*/
	/**
	* \page Properties
	* Properties are the main value modification widgets in Nuklear. Changing a value
	* can be achieved by dragging, adding/removing incremental steps on button click
	* or by directly typing a number.
	*
	* # Usage
	* Each property requires a unique name for identification that is also used for
	* displaying a label. If you want to use the same name multiple times make sure
	* add a '#' before your name. The '#' will not be shown but will generate a
	* unique ID. Each property also takes in a minimum and maximum value. If you want
	* to make use of the complete number range of a type just use the provided
	* type limits from `limits.h`. For example `INT_MIN` and `INT_MAX` for
	* `nk_property_int` and `nk_propertyi`. In additional each property takes in
	* a increment value that will be added or subtracted if either the increment
	* decrement button is clicked. Finally there is a value for increment per pixel
	* dragged that is added or subtracted from the value.
	*
	* ```c
	* int value = 0;
	* struct nk_context ctx;
	* nk_init_xxx(&ctx, ...);
	* while (1) {
	*     // Input
	*     Event evt;
	*     nk_input_begin(&ctx);
	*     while (GetEvent(&evt)) {
	*         if (evt.type == MOUSE_MOVE)
	*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
	*         else if (evt.type == [...]) {
	*             nk_input_xxx(...);
	*         }
	*     }
	*     nk_input_end(&ctx);
	*     //
	*     // Window
	*     if (nk_begin_xxx(...) {
	*         // Property
	*         nk_layout_row_dynamic(...);
	*         nk_property_int(ctx, "ID", INT_MIN, &value, INT_MAX, 1, 1);
	*     }
	*     nk_end(ctx);
	*     //
	*     // Draw
	*     const struct nk_command *cmd = 0;
	*     nk_foreach(cmd, &ctx) {
	*     switch (cmd->type) {
	*     case NK_COMMAND_LINE:
	*         your_draw_line_function(...)
	*         break;
	*     case NK_COMMAND_RECT
	*         your_draw_rect_function(...)
	*         break;
	*     case ...:
	*         // [...]
	*     }
	*     nk_clear(&ctx);
	* }
	* nk_free(&ctx);
	* ```
	*
	* # Reference
	* Function            | Description
	* --------------------|-------------------------------------------
	* \ref nk_property_int     | Integer property directly modifying a passed in value
	* \ref nk_property_float   | Float property directly modifying a passed in value
	* \ref nk_property_double  | Double property directly modifying a passed in value
	* \ref nk_propertyi        | Integer property returning the modified int value
	* \ref nk_propertyf        | Float property returning the modified float value
	* \ref nk_propertyd        | Double property returning the modified double value
	*
	
	* # # nk_property_int
	* Integer property directly modifying a passed in value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* nk_bool nk_property_int(struct nk_context *ctx, const char *name, int min, int *val, int max, int step, float inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Integer pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*
	* \returns `true(1)` if the value changed
	*/
	property_int :: proc(_: ^context, name: cstring, min: i32, val: ^i32, max: i32, step: i32, inc_per_pixel: f32) -> bool ---

	/**
	* # # nk_property_float
	* Float property directly modifying a passed in value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* nk_bool nk_property_float(struct nk_context *ctx, const char *name, float min, float *val, float max, float step, float inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Float pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*
	* \returns `true(1)` if the value changed
	*/
	property_float :: proc(_: ^context, name: cstring, min: f32, val: ^f32, max: f32, step: f32, inc_per_pixel: f32) -> bool ---

	/**
	* # # nk_property_double
	* Double property directly modifying a passed in value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* nk_bool nk_property_double(struct nk_context *ctx, const char *name, double min, double *val, double max, double step, double inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Double pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*
	* \returns `true(1)` if the value changed
	*/
	property_double :: proc(_: ^context, name: cstring, min: f64, val: ^f64, max: f64, step: f64, inc_per_pixel: f32) -> bool ---

	/**
	* # # nk_propertyi
	* Integer property modifying a passed in value and returning the new value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* int nk_propertyi(struct nk_context *ctx, const char *name, int min, int val, int max, int step, float inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current integer value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified integer value
	*/
	propertyi :: proc(_: ^context, name: cstring, min: i32, val: i32, max: i32, step: i32, inc_per_pixel: f32) -> i32 ---

	/**
	* # # nk_propertyf
	* Float property modifying a passed in value and returning the new value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* float nk_propertyf(struct nk_context *ctx, const char *name, float min, float val, float max, float step, float inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current float value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified float value
	*/
	propertyf :: proc(_: ^context, name: cstring, min: f32, val: f32, max: f32, step: f32, inc_per_pixel: f32) -> f32 ---

	/**
	* # # nk_propertyd
	* Float property modifying a passed in value and returning the new value
	* \warning To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* float nk_propertyd(struct nk_context *ctx, const char *name, double min, double val, double max, double step, double inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current double value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified double value
	*/
	propertyd :: proc(_: ^context, name: cstring, min: f64, val: f64, max: f64, step: f64, inc_per_pixel: f32) -> f64 ---
}

edit_flag :: enum u32 {
	READ_ONLY            = 0,
	AUTO_SELECT          = 1,
	SIG_ENTER            = 2,
	ALLOW_TAB            = 3,
	NO_CURSOR            = 4,
	SELECTABLE           = 5,
	CLIPBOARD            = 6,
	CTRL_ENTER_NEWLINE   = 7,
	NO_HORIZONTAL_SCROLL = 8,
	ALWAYS_INSERT_MODE   = 9,
	MULTILINE            = 10,
	GOTO_END_ON_ACTIVATE = 11,
}

/* =============================================================================
*
*                                  TEXT EDIT
*
* ============================================================================= */
edit_flags :: bit_set[edit_flag; u32]

edit_events :: enum u32 {
	ACTIVE      = 1,  /**!< edit widget is currently being modified */
	INACTIVE    = 2,  /**!< edit widget is not active and is not being modified */
	ACTIVATED   = 4,  /**!< edit widget went from state inactive to state active */
	DEACTIVATED = 8,  /**!< edit widget went from state active to state inactive */
	COMMITTED   = 16, /**!< edit widget has received an enter and lost focus */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	edit_string                 :: proc(_: ^context, _: edit_flags, buffer: cstring, len: ^i32, max: i32, _: plugin_filter) -> edit_flags ---
	edit_string_zero_terminated :: proc(_: ^context, _: edit_flags, buffer: cstring, max: i32, _: plugin_filter) -> edit_flags ---
	edit_buffer                 :: proc(^context, edit_flags, ^text_edit, plugin_filter) -> edit_flags ---
	edit_focus                  :: proc(_: ^context, flags: edit_flags) ---
	edit_unfocus                :: proc(^context) ---

	/* =============================================================================
	*
	*                                  CHART
	*
	* ============================================================================= */
	chart_begin            :: proc(_: ^context, _: chart_type, num: i32, min: f32, max: f32) -> bool ---
	chart_begin_colored    :: proc(_: ^context, _: chart_type, _: color, active: color, num: i32, min: f32, max: f32) -> bool ---
	chart_add_slot         :: proc(ctx: ^context, _: chart_type, count: i32, min_value: f32, max_value: f32) ---
	chart_add_slot_colored :: proc(ctx: ^context, _: chart_type, _: color, active: color, count: i32, min_value: f32, max_value: f32) ---
	chart_push             :: proc(^context, f32) -> chart_event ---
	chart_push_slot        :: proc(^context, f32, i32) -> chart_event ---
	chart_end              :: proc(^context) ---
	plot                   :: proc(_: ^context, _: chart_type, values: ^f32, count: i32, offset: i32) ---
	plot_function          :: proc(_: ^context, _: chart_type, userdata: rawptr, value_getter: proc "c" (user: rawptr, index: i32) -> f32, count: i32, offset: i32) ---

	/* =============================================================================
	*
	*                                  POPUP
	*
	* ============================================================================= */
	popup_begin      :: proc(_: ^context, _: popup_type, _: cstring, _: panel_flags, bounds: rect) -> bool ---
	popup_close      :: proc(^context) ---
	popup_end        :: proc(^context) ---
	popup_get_scroll :: proc(_: ^context, offset_x: ^u32, offset_y: ^u32) ---
	popup_set_scroll :: proc(_: ^context, offset_x: u32, offset_y: u32) ---

	/* =============================================================================
	*
	*                                  COMBOBOX
	*
	* ============================================================================= */
	combo              :: proc(_: ^context, items: ^cstring, count: i32, selected: i32, item_height: i32, size: vec2) -> i32 ---
	combo_separator    :: proc(_: ^context, items_separated_by_separator: cstring, separator: i32, selected: i32, count: i32, item_height: i32, size: vec2) -> i32 ---
	combo_string       :: proc(_: ^context, items_separated_by_zeros: cstring, selected: i32, count: i32, item_height: i32, size: vec2) -> i32 ---
	combo_callback     :: proc(_: ^context, item_getter: proc "c" (rawptr, i32, ^cstring), userdata: rawptr, selected: i32, count: i32, item_height: i32, size: vec2) -> i32 ---
	combobox           :: proc(_: ^context, items: ^cstring, count: i32, selected: ^i32, item_height: i32, size: vec2) -> bool ---
	combobox_string    :: proc(_: ^context, items_separated_by_zeros: cstring, selected: ^i32, count: i32, item_height: i32, size: vec2) -> bool ---
	combobox_separator :: proc(_: ^context, items_separated_by_separator: cstring, separator: i32, selected: ^i32, count: i32, item_height: i32, size: vec2) -> bool ---
	combobox_callback  :: proc(_: ^context, item_getter: proc "c" (rawptr, i32, ^cstring), _: rawptr, selected: ^i32, count: i32, item_height: i32, size: vec2) -> bool ---

	/* =============================================================================
	*
	*                                  ABSTRACT COMBOBOX
	*
	* ============================================================================= */
	combo_begin_text         :: proc(_: ^context, selected: cstring, _: i32, size: vec2) -> bool ---
	combo_begin_label        :: proc(_: ^context, selected: cstring, size: vec2) -> bool ---
	combo_begin_color        :: proc(_: ^context, color: color, size: vec2) -> bool ---
	combo_begin_symbol       :: proc(_: ^context, _: symbol_type, size: vec2) -> bool ---
	combo_begin_symbol_label :: proc(_: ^context, selected: cstring, _: symbol_type, size: vec2) -> bool ---
	combo_begin_symbol_text  :: proc(_: ^context, selected: cstring, _: i32, _: symbol_type, size: vec2) -> bool ---
	combo_begin_image        :: proc(_: ^context, img: image, size: vec2) -> bool ---
	combo_begin_image_label  :: proc(_: ^context, selected: cstring, _: image, size: vec2) -> bool ---
	combo_begin_image_text   :: proc(_: ^context, selected: cstring, _: i32, _: image, size: vec2) -> bool ---
	combo_item_label         :: proc(_: ^context, _: cstring, alignment: text_alignment) -> bool ---
	combo_item_text          :: proc(_: ^context, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	combo_item_image_label   :: proc(_: ^context, _: image, _: cstring, alignment: text_alignment) -> bool ---
	combo_item_image_text    :: proc(_: ^context, _: image, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	combo_item_symbol_label  :: proc(_: ^context, _: symbol_type, _: cstring, alignment: text_alignment) -> bool ---
	combo_item_symbol_text   :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	combo_close              :: proc(^context) ---
	combo_end                :: proc(^context) ---

	/* =============================================================================
	*
	*                                  CONTEXTUAL
	*
	* ============================================================================= */
	contextual_begin             :: proc(_: ^context, _: panel_flags, _: vec2, trigger_bounds: rect) -> bool ---
	contextual_item_text         :: proc(_: ^context, _: cstring, _: i32, align: text_alignment) -> bool ---
	contextual_item_label        :: proc(_: ^context, _: cstring, align: text_alignment) -> bool ---
	contextual_item_image_label  :: proc(_: ^context, _: image, _: cstring, alignment: text_alignment) -> bool ---
	contextual_item_image_text   :: proc(_: ^context, _: image, _: cstring, len: i32, alignment: text_alignment) -> bool ---
	contextual_item_symbol_label :: proc(_: ^context, _: symbol_type, _: cstring, alignment: text_alignment) -> bool ---
	contextual_item_symbol_text  :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	contextual_close             :: proc(^context) ---
	contextual_end               :: proc(^context) ---

	/* =============================================================================
	*
	*                                  TOOLTIP
	*
	* ============================================================================= */
	tooltip                  :: proc(^context, cstring) ---
	tooltip_offset           :: proc(ctx: ^context, text: cstring, position: tooltip_pos, offset: vec2) ---
	do_tooltip               :: proc(^context, cstring, rect) ---
	do_tooltip_delay         :: proc(^context, cstring, rect, ^f32) ---
	do_tooltip_delay_clicked :: proc(_: ^context, _: cstring, _: rect, timer: ^f32, _: ^bool) ---
	tooltip_begin            :: proc(_: ^context, width: f32) -> bool ---
	tooltip_begin_offset     :: proc(^context, f32, tooltip_pos, vec2) -> bool ---
	tooltip_end              :: proc(^context) ---

	/* =============================================================================
	*
	*                                  MENU
	*
	* ============================================================================= */
	menubar_begin           :: proc(^context) ---
	menubar_end             :: proc(^context) ---
	menu_begin_text         :: proc(_: ^context, title: cstring, title_len: i32, align: text_alignment, size: vec2) -> bool ---
	menu_begin_label        :: proc(_: ^context, _: cstring, align: text_alignment, size: vec2) -> bool ---
	menu_begin_image        :: proc(_: ^context, _: cstring, _: image, size: vec2) -> bool ---
	menu_begin_image_text   :: proc(_: ^context, _: cstring, _: i32, align: text_alignment, _: image, size: vec2) -> bool ---
	menu_begin_image_label  :: proc(_: ^context, _: cstring, align: text_alignment, _: image, size: vec2) -> bool ---
	menu_begin_symbol       :: proc(_: ^context, _: cstring, _: symbol_type, size: vec2) -> bool ---
	menu_begin_symbol_text  :: proc(_: ^context, _: cstring, _: i32, align: text_alignment, _: symbol_type, size: vec2) -> bool ---
	menu_begin_symbol_label :: proc(_: ^context, _: cstring, align: text_alignment, _: symbol_type, size: vec2) -> bool ---
	menu_item_text          :: proc(_: ^context, _: cstring, _: i32, align: text_alignment) -> bool ---
	menu_item_label         :: proc(_: ^context, _: cstring, alignment: text_alignment) -> bool ---
	menu_item_image_label   :: proc(_: ^context, _: image, _: cstring, alignment: text_alignment) -> bool ---
	menu_item_image_text    :: proc(_: ^context, _: image, _: cstring, len: i32, alignment: text_alignment) -> bool ---
	menu_item_symbol_text   :: proc(_: ^context, _: symbol_type, _: cstring, _: i32, alignment: text_alignment) -> bool ---
	menu_item_symbol_label  :: proc(_: ^context, _: symbol_type, _: cstring, alignment: text_alignment) -> bool ---
	menu_close              :: proc(^context) ---
	menu_end                :: proc(^context) ---
}

/* =============================================================================
*
*                                  STYLE
*
* ============================================================================= */
WIDGET_DISABLED_FACTOR :: 0.5

style_colors :: enum u32 {
	TEXT                    = 0,
	WINDOW                  = 1,
	HEADER                  = 2,
	BORDER                  = 3,
	BUTTON                  = 4,
	BUTTON_HOVER            = 5,
	BUTTON_ACTIVE           = 6,
	TOGGLE                  = 7,
	TOGGLE_HOVER            = 8,
	TOGGLE_CURSOR           = 9,
	SELECT                  = 10,
	SELECT_ACTIVE           = 11,
	SLIDER                  = 12,
	SLIDER_CURSOR           = 13,
	SLIDER_CURSOR_HOVER     = 14,
	SLIDER_CURSOR_ACTIVE    = 15,
	PROPERTY                = 16,
	EDIT                    = 17,
	EDIT_CURSOR             = 18,
	COMBO                   = 19,
	CHART                   = 20,
	CHART_COLOR             = 21,
	CHART_COLOR_HIGHLIGHT   = 22,
	SCROLLBAR               = 23,
	SCROLLBAR_CURSOR        = 24,
	SCROLLBAR_CURSOR_HOVER  = 25,
	SCROLLBAR_CURSOR_ACTIVE = 26,
	TAB_HEADER              = 27,
	KNOB                    = 28,
	KNOB_CURSOR             = 29,
	KNOB_CURSOR_HOVER       = 30,
	KNOB_CURSOR_ACTIVE      = 31,
}

style_cursor :: enum u32 {
	ARROW                      = 0,
	TEXT                       = 1,
	MOVE                       = 2,
	RESIZE_VERTICAL            = 3,
	RESIZE_HORIZONTAL          = 4,
	RESIZE_TOP_LEFT_DOWN_RIGHT = 5,
	RESIZE_TOP_RIGHT_DOWN_LEFT = 6,
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	style_default           :: proc(^context) ---
	style_from_table        :: proc(^context, ^color) ---
	style_load_cursor       :: proc(^context, style_cursor, ^cursor) ---
	style_load_all_cursors  :: proc(^context, ^cursor) ---
	style_get_color_by_name :: proc(style_colors) -> cstring ---
	style_set_font          :: proc(^context, ^user_font) ---
	style_set_cursor        :: proc(^context, style_cursor) -> bool ---
	style_show_cursor       :: proc(^context) ---
	style_hide_cursor       :: proc(^context) ---
	style_push_font         :: proc(^context, ^user_font) -> bool ---
	style_push_float        :: proc(^context, ^f32, f32) -> bool ---
	style_push_vec2         :: proc(^context, ^vec2, vec2) -> bool ---
	style_push_style_item   :: proc(^context, ^style_item, style_item) -> bool ---
	style_push_flags        :: proc(^context, ^Flags, Flags) -> bool ---
	style_push_color        :: proc(^context, ^color, color) -> bool ---
	style_pop_font          :: proc(^context) -> bool ---
	style_pop_float         :: proc(^context) -> bool ---
	style_pop_vec2          :: proc(^context) -> bool ---
	style_pop_style_item    :: proc(^context) -> bool ---
	style_pop_flags         :: proc(^context) -> bool ---
	style_pop_color         :: proc(^context) -> bool ---

	/* =============================================================================
	*
	*                                  COLOR
	*
	* ============================================================================= */
	rgb            :: proc(r: i32, g: i32, b: i32) -> color ---
	rgb_iv         :: proc(rgb: ^i32) -> color ---
	rgb_bv         :: proc(rgb: ^byte) -> color ---
	rgb_f          :: proc(r: f32, g: f32, b: f32) -> color ---
	rgb_fv         :: proc(rgb: ^f32) -> color ---
	rgb_cf         :: proc(_c: colorf) -> color ---
	rgb_hex        :: proc(rgb: cstring) -> color ---
	rgb_factor     :: proc(col: color, factor: f32) -> color ---
	rgba           :: proc(r: i32, g: i32, b: i32, a: i32) -> color ---
	rgba_u32       :: proc(u32) -> color ---
	rgba_iv        :: proc(rgba: ^i32) -> color ---
	rgba_bv        :: proc(rgba: ^byte) -> color ---
	rgba_f         :: proc(r: f32, g: f32, b: f32, a: f32) -> color ---
	rgba_fv        :: proc(rgba: ^f32) -> color ---
	rgba_cf        :: proc(_c: colorf) -> color ---
	rgba_hex       :: proc(rgb: cstring) -> color ---
	hsva_colorf    :: proc(h: f32, s: f32, v: f32, a: f32) -> colorf ---
	hsva_colorfv   :: proc(_c: ^f32) -> colorf ---
	colorf_hsva_f  :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, out_a: ^f32, _in: colorf) ---
	colorf_hsva_fv :: proc(hsva: ^f32, _in: colorf) ---
	hsv            :: proc(h: i32, s: i32, v: i32) -> color ---
	hsv_iv         :: proc(hsv: ^i32) -> color ---
	hsv_bv         :: proc(hsv: ^byte) -> color ---
	hsv_f          :: proc(h: f32, s: f32, v: f32) -> color ---
	hsv_fv         :: proc(hsv: ^f32) -> color ---
	hsva           :: proc(h: i32, s: i32, v: i32, a: i32) -> color ---
	hsva_iv        :: proc(hsva: ^i32) -> color ---
	hsva_bv        :: proc(hsva: ^byte) -> color ---
	hsva_f         :: proc(h: f32, s: f32, v: f32, a: f32) -> color ---
	hsva_fv        :: proc(hsva: ^f32) -> color ---

	/* color (conversion nuklear --> user) */
	color_f        :: proc(r: ^f32, g: ^f32, b: ^f32, a: ^f32, _: color) ---
	color_fv       :: proc(rgba_out: ^f32, _: color) ---
	color_cf       :: proc(color) -> colorf ---
	color_d        :: proc(r: ^f64, g: ^f64, b: ^f64, a: ^f64, _: color) ---
	color_dv       :: proc(rgba_out: ^f64, _: color) ---
	color_u32      :: proc(color) -> u32 ---
	color_hex_rgba :: proc(output: cstring, _: color) ---
	color_hex_rgb  :: proc(output: cstring, _: color) ---
	color_hsv_i    :: proc(out_h: ^i32, out_s: ^i32, out_v: ^i32, _: color) ---
	color_hsv_b    :: proc(out_h: ^byte, out_s: ^byte, out_v: ^byte, _: color) ---
	color_hsv_iv   :: proc(hsv_out: ^i32, _: color) ---
	color_hsv_bv   :: proc(hsv_out: ^byte, _: color) ---
	color_hsv_f    :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, _: color) ---
	color_hsv_fv   :: proc(hsv_out: ^f32, _: color) ---
	color_hsva_i   :: proc(h: ^i32, s: ^i32, v: ^i32, a: ^i32, _: color) ---
	color_hsva_b   :: proc(h: ^byte, s: ^byte, v: ^byte, a: ^byte, _: color) ---
	color_hsva_iv  :: proc(hsva_out: ^i32, _: color) ---
	color_hsva_bv  :: proc(hsva_out: ^byte, _: color) ---
	color_hsva_f   :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, out_a: ^f32, _: color) ---
	color_hsva_fv  :: proc(hsva_out: ^f32, _: color) ---

	/* =============================================================================
	*
	*                                  IMAGE
	*
	* ============================================================================= */
	handle_ptr        :: proc(rawptr) -> handle ---
	handle_id         :: proc(i32) -> handle ---
	image_handle      :: proc(handle) -> image ---
	image_ptr         :: proc(rawptr) -> image ---
	image_id          :: proc(i32) -> image ---
	image_is_subimage :: proc(img: ^image) -> bool ---
	subimage_ptr      :: proc(_: rawptr, w: u16, h: u16, sub_region: rect) -> image ---
	subimage_id       :: proc(_: i32, w: u16, h: u16, sub_region: rect) -> image ---
	subimage_handle   :: proc(_: handle, w: u16, h: u16, sub_region: rect) -> image ---

	/* =============================================================================
	*
	*                                  9-SLICE
	*
	* ============================================================================= */
	nine_slice_handle       :: proc(_: handle, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---
	nine_slice_ptr          :: proc(_: rawptr, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---
	nine_slice_id           :: proc(_: i32, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---
	nine_slice_is_sub9slice :: proc(img: ^nine_slice) -> i32 ---
	sub9slice_ptr           :: proc(_: rawptr, w: u16, h: u16, sub_region: rect, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---
	sub9slice_id            :: proc(_: i32, w: u16, h: u16, sub_region: rect, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---
	sub9slice_handle        :: proc(_: handle, w: u16, h: u16, sub_region: rect, l: u16, t: u16, r: u16, b: u16) -> nine_slice ---

	/* =============================================================================
	*
	*                                  MATH
	*
	* ============================================================================= */
	murmur_hash             :: proc(key: rawptr, len: i32, seed: Hash) -> Hash ---
	triangle_from_direction :: proc(result: ^vec2, r: rect, pad_x: f32, pad_y: f32, _: heading) ---
	vec2v                   :: proc(xy: ^f32) -> vec2 ---
	vec2iv                  :: proc(xy: ^i32) -> vec2 ---
	get_null_rect           :: proc() -> rect ---
	recta                   :: proc(pos: vec2, size: vec2) -> rect ---
	rectv                   :: proc(xywh: ^f32) -> rect ---
	rectiv                  :: proc(xywh: ^i32) -> rect ---
	rect_pos                :: proc(rect) -> vec2 ---
	rect_size               :: proc(rect) -> vec2 ---

	/* =============================================================================
	*
	*                                  STRING
	*
	* ============================================================================= */
	strlen                :: proc(str: cstring) -> i32 ---
	stricmp               :: proc(s1: cstring, s2: cstring) -> i32 ---
	stricmpn              :: proc(s1: cstring, s2: cstring, n: i32) -> i32 ---
	strtoi                :: proc(str: cstring, endptr: ^cstring) -> i32 ---
	strtof                :: proc(str: cstring, endptr: ^cstring) -> f32 ---
	strtod                :: proc(str: cstring, endptr: ^cstring) -> f64 ---
	strfilter             :: proc(text: cstring, regexp: cstring) -> i32 ---
	strmatch_fuzzy_string :: proc(str: cstring, pattern: cstring, out_score: ^i32) -> i32 ---
	strmatch_fuzzy_text   :: proc(txt: cstring, txt_len: i32, pattern: cstring, out_score: ^i32) -> i32 ---

	/* =============================================================================
	*
	*                                  UTF-8
	*
	* ============================================================================= */
	utf_decode :: proc(cstring, ^rune, i32) -> i32 ---
	utf_encode :: proc(rune, cstring, i32) -> i32 ---
	utf_len    :: proc(_: cstring, byte_len: i32) -> i32 ---
	utf_at     :: proc(buffer: cstring, length: i32, index: i32, unicode: ^rune, len: ^i32) -> cstring ---
}

/* ===============================================================
*
*                          FONT
*
* ===============================================================*/
/**
* \page Font
* Font handling in this library was designed to be quite customizable and lets
* you decide what you want to use and what you want to provide. There are three
* different ways to use the font atlas. The first two will use your font
* handling scheme and only requires essential data to run nuklear. The next
* slightly more advanced features is font handling with vertex buffer output.
* Finally the most complex API wise is using nuklear's font baking API.
*
* # Using your own implementation without vertex buffer output
*
* So first up the easiest way to do font handling is by just providing a
* `nk_user_font` struct which only requires the height in pixel of the used
* font and a callback to calculate the width of a string. This way of handling
* fonts is best fitted for using the normal draw shape command API where you
* do all the text drawing yourself and the library does not require any kind
* of deeper knowledge about which font handling mechanism you use.
* IMPORTANT: the `nk_user_font` pointer provided to nuklear has to persist
* over the complete life time! I know this sucks but it is currently the only
* way to switch between fonts.
*
* ```c
*     float your_text_width_calculation(nk_handle handle, float height, const char *text, int len)
*     {
*         your_font_type *type = handle.ptr;
*         float text_width = ...;
*         return text_width;
*     }
*
*     struct nk_user_font font;
*     font.userdata.ptr = &your_font_class_or_struct;
*     font.height = your_font_height;
*     font.width = your_text_width_calculation;
*
*     struct nk_context ctx;
*     nk_init_default(&ctx, &font);
* ```
* # Using your own implementation with vertex buffer output
*
* While the first approach works fine if you don't want to use the optional
* vertex buffer output it is not enough if you do. To get font handling working
* for these cases you have to provide two additional parameters inside the
* `nk_user_font`. First a texture atlas handle used to draw text as subimages
* of a bigger font atlas texture and a callback to query a character's glyph
* information (offset, size, ...). So it is still possible to provide your own
* font and use the vertex buffer output.
*
* ```c
*     float your_text_width_calculation(nk_handle handle, float height, const char *text, int len)
*     {
*         your_font_type *type = handle.ptr;
*         float text_width = ...;
*         return text_width;
*     }
*     void query_your_font_glyph(nk_handle handle, float font_height, struct nk_user_font_glyph *glyph, nk_rune codepoint, nk_rune next_codepoint)
*     {
*         your_font_type *type = handle.ptr;
*         glyph.width = ...;
*         glyph.height = ...;
*         glyph.xadvance = ...;
*         glyph.uv[0].x = ...;
*         glyph.uv[0].y = ...;
*         glyph.uv[1].x = ...;
*         glyph.uv[1].y = ...;
*         glyph.offset.x = ...;
*         glyph.offset.y = ...;
*     }
*
*     struct nk_user_font font;
*     font.userdata.ptr = &your_font_class_or_struct;
*     font.height = your_font_height;
*     font.width = your_text_width_calculation;
*     font.query = query_your_font_glyph;
*     font.texture.id = your_font_texture;
*
*     struct nk_context ctx;
*     nk_init_default(&ctx, &font);
* ```
*
* # Nuklear font baker
*
* The final approach if you do not have a font handling functionality or don't
* want to use it in this library is by using the optional font baker.
* The font baker APIs can be used to create a font plus font atlas texture
* and can be used with or without the vertex buffer output.
*
* It still uses the `nk_user_font` struct and the two different approaches
* previously stated still work. The font baker is not located inside
* `nk_context` like all other systems since it can be understood as more of
* an extension to nuklear and does not really depend on any `nk_context` state.
*
* Font baker need to be initialized first by one of the nk_font_atlas_init_xxx
* functions. If you don't care about memory just call the default version
* `nk_font_atlas_init_default` which will allocate all memory from the standard library.
* If you want to control memory allocation but you don't care if the allocated
* memory is temporary and therefore can be freed directly after the baking process
* is over or permanent you can call `nk_font_atlas_init`.
*
* After successfully initializing the font baker you can add Truetype(.ttf) fonts from
* different sources like memory or from file by calling one of the `nk_font_atlas_add_xxx`.
* functions. Adding font will permanently store each font, font config and ttf memory block(!)
* inside the font atlas and allows to reuse the font atlas. If you don't want to reuse
* the font baker by for example adding additional fonts you can call
* `nk_font_atlas_cleanup` after the baking process is over (after calling nk_font_atlas_end).
*
* As soon as you added all fonts you wanted you can now start the baking process
* for every selected glyph to image by calling `nk_font_atlas_bake`.
* The baking process returns image memory, width and height which can be used to
* either create your own image object or upload it to any graphics library.
* No matter which case you finally have to call `nk_font_atlas_end` which
* will free all temporary memory including the font atlas image so make sure
* you created our texture beforehand. `nk_font_atlas_end` requires a handle
* to your font texture or object and optionally fills a `struct nk_draw_null_texture`
* which can be used for the optional vertex output. If you don't want it just
* set the argument to `NULL`.
*
* At this point you are done and if you don't want to reuse the font atlas you
* can call `nk_font_atlas_cleanup` to free all truetype blobs and configuration
* memory. Finally if you don't use the font atlas and any of it's fonts anymore
* you need to call `nk_font_atlas_clear` to free all memory still being used.
*
* ```c
*     struct nk_font_atlas atlas;
*     nk_font_atlas_init_default(&atlas);
*     nk_font_atlas_begin(&atlas);
*     nk_font *font = nk_font_atlas_add_from_file(&atlas, "Path/To/Your/TTF_Font.ttf", 13, 0);
*     nk_font *font2 = nk_font_atlas_add_from_file(&atlas, "Path/To/Your/TTF_Font2.ttf", 16, 0);
*     const void* img = nk_font_atlas_bake(&atlas, &img_width, &img_height, NK_FONT_ATLAS_RGBA32);
*     nk_font_atlas_end(&atlas, nk_handle_id(texture), 0);
*
*     struct nk_context ctx;
*     nk_init_default(&ctx, &font->handle);
*     while (1) {
*
*     }
*     nk_font_atlas_clear(&atlas);
* ```
* The font baker API is probably the most complex API inside this library and
* I would suggest reading some of my examples `example/` to get a grip on how
* to use the font atlas. There are a number of details I left out. For example
* how to merge fonts, configure a font with `nk_font_config` to use other languages,
* use another texture coordinate format and a lot more:
*
* ```c
*     struct nk_font_config cfg = nk_font_config(font_pixel_height);
*     cfg.merge_mode = nk_false or nk_true;
*     cfg.range = nk_font_korean_glyph_ranges();
*     cfg.coord_type = NK_COORD_PIXEL;
*     nk_font *font = nk_font_atlas_add_from_file(&atlas, "Path/To/Your/TTF_Font.ttf", 13, &cfg);
* ```
*/
user_font_glyph    :: struct {}
text_width_f       :: proc "c" (_: handle, h: f32, _: cstring, len: i32) -> f32
query_font_glyph_f :: proc "c" (handle: handle, font_height: f32, glyph: ^user_font_glyph, codepoint: rune, next_codepoint: rune)
user_font          :: struct {}

/* ==============================================================
*
*                          MEMORY BUFFER
*
* ===============================================================*/
/**
* \page Memory Buffer
* A basic (double)-buffer with linear allocation and resetting as only
* freeing policy. The buffer's main purpose is to control all memory management
* inside the GUI toolkit and still leave memory control as much as possible in
* the hand of the user while also making sure the library is easy to use if
* not as much control is needed.
* In general all memory inside this library can be provided from the user in
* three different ways.
*
* The first way and the one providing most control is by just passing a fixed
* size memory block. In this case all control lies in the hand of the user
* since he can exactly control where the memory comes from and how much memory
* the library should consume. Of course using the fixed size API removes the
* ability to automatically resize a buffer if not enough memory is provided so
* you have to take over the resizing. While being a fixed sized buffer sounds
* quite limiting, it is very effective in this library since the actual memory
* consumption is quite stable and has a fixed upper bound for a lot of cases.
*
* If you don't want to think about how much memory the library should allocate
* at all time or have a very dynamic UI with unpredictable memory consumption
* habits but still want control over memory allocation you can use the dynamic
* allocator based API. The allocator consists of two callbacks for allocating
* and freeing memory and optional userdata so you can plugin your own allocator.
*
* The final and easiest way can be used by defining
* NK_INCLUDE_DEFAULT_ALLOCATOR which uses the standard library memory
* allocation functions malloc and free and takes over complete control over
* memory in this library.
*/
memory_status :: struct {
	memory:    rawptr,
	type:      u32,
	size:      uint,
	allocated: uint,
	needed:    uint,
	calls:     uint,
}

allocation_type :: enum u32 {
	FIXED   = 0,
	DYNAMIC = 1,
}

buffer_allocation_type :: enum u32 {
	FRONT = 0,
	BACK  = 1,
}

buffer_marker :: struct {
	active: bool,
	offset: uint,
}

memory :: struct {
	ptr:  rawptr,
	size: uint,
}

/* ============================================================================
*
*                                  API
*
* =========================================================================== */
buffer :: struct {}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	buffer_init         :: proc(_: ^buffer, _: ^allocator, size: uint) ---
	buffer_init_fixed   :: proc(_: ^buffer, memory: rawptr, size: uint) ---
	buffer_info         :: proc(^memory_status, ^buffer) ---
	buffer_push         :: proc(_: ^buffer, type: buffer_allocation_type, memory: rawptr, size: uint, align: uint) ---
	buffer_mark         :: proc(_: ^buffer, type: buffer_allocation_type) ---
	buffer_reset        :: proc(_: ^buffer, type: buffer_allocation_type) ---
	buffer_clear        :: proc(^buffer) ---
	buffer_free         :: proc(^buffer) ---
	buffer_memory       :: proc(^buffer) -> rawptr ---
	buffer_memory_const :: proc(^buffer) -> rawptr ---
	buffer_total        :: proc(^buffer) -> uint ---
}

/* ==============================================================
*
*                          STRING
*
* ===============================================================*/
/**  Basic string buffer which is only used in context with the text editor
*  to manage and manipulate dynamic or fixed size string content. This is _NOT_
*  the default string handling method. The only instance you should have any contact
*  with this API is if you interact with an `nk_text_edit` object inside one of the
*  copy and paste functions and even there only for more advanced cases. */
str :: struct {
	buffer: buffer,
	len:    i32, /**!< in codepoints/runes/glyphs */
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	str_init              :: proc(_: ^str, _: ^allocator, size: uint) ---
	str_init_fixed        :: proc(_: ^str, memory: rawptr, size: uint) ---
	str_clear             :: proc(^str) ---
	str_free              :: proc(^str) ---
	str_append_text_char  :: proc(^str, cstring, i32) -> i32 ---
	str_append_str_char   :: proc(^str, cstring) -> i32 ---
	str_append_text_utf8  :: proc(^str, cstring, i32) -> i32 ---
	str_append_str_utf8   :: proc(^str, cstring) -> i32 ---
	str_append_text_runes :: proc(^str, ^rune, i32) -> i32 ---
	str_append_str_runes  :: proc(^str, ^rune) -> i32 ---
	str_insert_at_char    :: proc(_: ^str, pos: i32, _: cstring, _: i32) -> i32 ---
	str_insert_at_rune    :: proc(_: ^str, pos: i32, _: cstring, _: i32) -> i32 ---
	str_insert_text_char  :: proc(_: ^str, pos: i32, _: cstring, _: i32) -> i32 ---
	str_insert_str_char   :: proc(_: ^str, pos: i32, _: cstring) -> i32 ---
	str_insert_text_utf8  :: proc(_: ^str, pos: i32, _: cstring, _: i32) -> i32 ---
	str_insert_str_utf8   :: proc(_: ^str, pos: i32, _: cstring) -> i32 ---
	str_insert_text_runes :: proc(_: ^str, pos: i32, _: ^rune, _: i32) -> i32 ---
	str_insert_str_runes  :: proc(_: ^str, pos: i32, _: ^rune) -> i32 ---
	str_remove_chars      :: proc(_: ^str, len: i32) ---
	str_remove_runes      :: proc(str: ^str, len: i32) ---
	str_delete_chars      :: proc(_: ^str, pos: i32, len: i32) ---
	str_delete_runes      :: proc(_: ^str, pos: i32, len: i32) ---
	str_at_char           :: proc(_: ^str, pos: i32) -> cstring ---
	str_at_rune           :: proc(_: ^str, pos: i32, unicode: ^rune, len: ^i32) -> cstring ---
	str_rune_at           :: proc(_: ^str, pos: i32) -> rune ---
	str_at_char_const     :: proc(_: ^str, pos: i32) -> cstring ---
	str_at_const          :: proc(_: ^str, pos: i32, unicode: ^rune, len: ^i32) -> cstring ---
	str_get               :: proc(^str) -> cstring ---
	str_get_const         :: proc(^str) -> cstring ---
	str_len               :: proc(^str) -> i32 ---
	str_len_char          :: proc(^str) -> i32 ---
}

TEXTEDIT_UNDOSTATECOUNT     :: 99
TEXTEDIT_UNDOCHARCOUNT      :: 999

clipboard :: struct {
	userdata: handle,
	paste:    plugin_paste,
	copy:     plugin_copy,
}

text_undo_record :: struct {
	_where:        i32,
	insert_length: i16,
	delete_length: i16,
	char_storage:  i16,
}

text_undo_state :: struct {
	undo_rec:        [99]text_undo_record,
	undo_char:       [999]rune,
	undo_point:      i16,
	redo_point:      i16,
	undo_char_point: i16,
	redo_char_point: i16,
}

text_edit_type :: enum u32 {
	SINGLE_LINE = 0,
	MULTI_LINE  = 1,
}

text_edit_mode :: enum u32 {
	VIEW    = 0,
	INSERT  = 1,
	REPLACE = 2,
}

text_edit :: struct {}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/** filter function */
	filter_default            :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_ascii              :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_float              :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_decimal            :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_hex                :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_oct                :: proc(_: ^text_edit, unicode: rune) -> bool ---
	filter_binary             :: proc(_: ^text_edit, unicode: rune) -> bool ---
	textedit_init             :: proc(_: ^text_edit, _: ^allocator, size: uint) ---
	textedit_init_fixed       :: proc(_: ^text_edit, memory: rawptr, size: uint) ---
	textedit_free             :: proc(^text_edit) ---
	textedit_text             :: proc(_: ^text_edit, _: cstring, total_len: i32) ---
	textedit_delete           :: proc(_: ^text_edit, _where: i32, len: i32) ---
	textedit_delete_selection :: proc(^text_edit) ---
	textedit_select_all       :: proc(^text_edit) ---
	textedit_cut              :: proc(^text_edit) -> bool ---
	textedit_paste            :: proc(_: ^text_edit, _: cstring, len: i32) -> bool ---
	textedit_undo             :: proc(^text_edit) ---
	textedit_redo             :: proc(^text_edit) ---
}

/* ===============================================================
*
*                          DRAWING
*
* ===============================================================*/
/**
* \page Drawing
* This library was designed to be render backend agnostic so it does
* not draw anything to screen. Instead all drawn shapes, widgets
* are made of, are buffered into memory and make up a command queue.
* Each frame therefore fills the command buffer with draw commands
* that then need to be executed by the user and his own render backend.
* After that the command buffer needs to be cleared and a new frame can be
* started. It is probably important to note that the command buffer is the main
* drawing API and the optional vertex buffer API only takes this format and
* converts it into a hardware accessible format.
*
* To use the command queue to draw your own widgets you can access the
* command buffer of each window by calling `nk_window_get_canvas` after
* previously having called `nk_begin`:
*
* ```c
*     void draw_red_rectangle_widget(struct nk_context *ctx)
*     {
*         struct nk_command_buffer *canvas;
*         struct nk_input *input = &ctx->input;
*         canvas = nk_window_get_canvas(ctx);
*
*         struct nk_rect space;
*         enum nk_widget_layout_states state;
*         state = nk_widget(&space, ctx);
*         if (!state) return;
*
*         if (state != NK_WIDGET_ROM)
*             update_your_widget_by_user_input(...);
*         nk_fill_rect(canvas, space, 0, nk_rgb(255,0,0));
*     }
*
*     if (nk_begin(...)) {
*         nk_layout_row_dynamic(ctx, 25, 1);
*         draw_red_rectangle_widget(ctx);
*     }
*     nk_end(..)
*
* ```
* Important to know if you want to create your own widgets is the `nk_widget`
* call. It allocates space on the panel reserved for this widget to be used,
* but also returns the state of the widget space. If your widget is not seen and does
* not have to be updated it is '0' and you can just return. If it only has
* to be drawn the state will be `NK_WIDGET_ROM` otherwise you can do both
* update and draw your widget. The reason for separating is to only draw and
* update what is actually necessary which is crucial for performance.
*/
command_type :: enum u32 {
	NOP              = 0,
	SCISSOR          = 1,
	LINE             = 2,
	CURVE            = 3,
	RECT             = 4,
	RECT_FILLED      = 5,
	RECT_MULTI_COLOR = 6,
	CIRCLE           = 7,
	CIRCLE_FILLED    = 8,
	ARC              = 9,
	ARC_FILLED       = 10,
	TRIANGLE         = 11,
	TRIANGLE_FILLED  = 12,
	POLYGON          = 13,
	POLYGON_FILLED   = 14,
	POLYLINE         = 15,
	TEXT             = 16,
	IMAGE            = 17,
	CUSTOM           = 18,
}

/** command base and header of every command inside the buffer */
command :: struct {}

command_scissor :: struct {
	header: command,
	x, y:   i16,
	w, h:   u16,
}

command_line :: struct {
	header:         command,
	line_thickness: u16,
	begin:          Vec2I,
	end:            Vec2I,
	color:          color,
}

command_curve :: struct {
	header:         command,
	line_thickness: u16,
	begin:          Vec2I,
	end:            Vec2I,
	ctrl:           [2]Vec2I,
	color:          color,
}

command_rect :: struct {
	header:         command,
	rounding:       u16,
	line_thickness: u16,
	x, y:           i16,
	w, h:           u16,
	color:          color,
}

command_rect_filled :: struct {
	header:   command,
	rounding: u16,
	x, y:     i16,
	w, h:     u16,
	color:    color,
}

command_rect_multi_color :: struct {
	header: command,
	x, y:   i16,
	w, h:   u16,
	left:   color,
	top:    color,
	bottom: color,
	right:  color,
}

command_triangle :: struct {
	header:         command,
	line_thickness: u16,
	a:              Vec2I,
	b:              Vec2I,
	_c:             Vec2I,
	color:          color,
}

command_triangle_filled :: struct {
	header: command,
	a:      Vec2I,
	b:      Vec2I,
	_c:     Vec2I,
	color:  color,
}

command_circle :: struct {
	header:         command,
	x, y:           i16,
	line_thickness: u16,
	w, h:           u16,
	color:          color,
}

command_circle_filled :: struct {
	header: command,
	x, y:   i16,
	w, h:   u16,
	color:  color,
}

command_arc :: struct {
	header:         command,
	cx, cy:         i16,
	r:              u16,
	line_thickness: u16,
	a:              [2]f32,
	color:          color,
}

command_arc_filled :: struct {
	header: command,
	cx, cy: i16,
	r:      u16,
	a:      [2]f32,
	color:  color,
}

command_polygon :: struct {
	header:         command,
	color:          color,
	line_thickness: u16,
	point_count:    u16,
	points:         [1]Vec2I,
}

command_polygon_filled :: struct {
	header:      command,
	color:       color,
	point_count: u16,
	points:      [1]Vec2I,
}

command_polyline :: struct {
	header:         command,
	color:          color,
	line_thickness: u16,
	point_count:    u16,
	points:         [1]Vec2I,
}

command_image :: struct {
	header: command,
	x, y:   i16,
	w, h:   u16,
	img:    image,
	col:    color,
}

command_custom_callback :: proc "c" (canvas: rawptr, x: i16, y: i16, w: u16, h: u16, callback_data: handle)

command_custom :: struct {
	header:        command,
	x, y:          i16,
	w, h:          u16,
	callback_data: handle,
	callback:      command_custom_callback,
}

command_text :: struct {
	header:     command,
	font:       ^user_font,
	background: color,
	foreground: color,
	x, y:       i16,
	w, h:       u16,
	height:     f32,
	length:     i32,
	_string:    [2]i8,
}

command_clipping :: enum u32 {
	OFF = 0,
	ON  = 1,
}

command_buffer :: struct {}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	/** shape outlines */
	stroke_line     :: proc(b: ^command_buffer, x0: f32, y0: f32, x1: f32, y1: f32, line_thickness: f32, _: color) ---
	stroke_curve    :: proc(_: ^command_buffer, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, line_thickness: f32, _: color) ---
	stroke_rect     :: proc(_: ^command_buffer, _: rect, rounding: f32, line_thickness: f32, _: color) ---
	stroke_circle   :: proc(_: ^command_buffer, _: rect, line_thickness: f32, _: color) ---
	stroke_arc      :: proc(_: ^command_buffer, cx: f32, cy: f32, radius: f32, a_min: f32, a_max: f32, line_thickness: f32, _: color) ---
	stroke_triangle :: proc(_: ^command_buffer, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, line_thichness: f32, _: color) ---
	stroke_polyline :: proc(_: ^command_buffer, points: ^f32, point_count: i32, line_thickness: f32, col: color) ---
	stroke_polygon  :: proc(_: ^command_buffer, points: ^f32, point_count: i32, line_thickness: f32, _: color) ---

	/** filled shades */
	fill_rect             :: proc(_: ^command_buffer, _: rect, rounding: f32, _: color) ---
	fill_rect_multi_color :: proc(_: ^command_buffer, _: rect, left: color, top: color, right: color, bottom: color) ---
	fill_circle           :: proc(^command_buffer, rect, color) ---
	fill_arc              :: proc(_: ^command_buffer, cx: f32, cy: f32, radius: f32, a_min: f32, a_max: f32, _: color) ---
	fill_triangle         :: proc(_: ^command_buffer, x0: f32, y0: f32, x1: f32, y1: f32, x2: f32, y2: f32, _: color) ---
	fill_polygon          :: proc(_: ^command_buffer, points: ^f32, point_count: i32, _: color) ---

	/** misc */
	draw_image      :: proc(^command_buffer, rect, ^image, color) ---
	draw_nine_slice :: proc(^command_buffer, rect, ^nine_slice, color) ---
	draw_text       :: proc(_: ^command_buffer, _: rect, text: cstring, len: i32, _: ^user_font, _: color, _: color) ---
	push_scissor    :: proc(^command_buffer, rect) ---
	push_custom     :: proc(_: ^command_buffer, _: rect, _: command_custom_callback, usr: handle) ---
}

/* ===============================================================
*
*                          INPUT
*
* ===============================================================*/
mouse_button :: struct {
	down:        bool,
	clicked:     u32,
	clicked_pos: vec2,
}

mouse :: struct {
	buttons:      [6]mouse_button,
	pos:          vec2,
	prev:         vec2,
	delta:        vec2,
	scroll_delta: vec2,
	grab:         u8,
	grabbed:      u8,
	ungrab:       u8,
}

key :: struct {
	down:    bool,
	clicked: u32,
}

keyboard :: struct {
	keys:     [43]key,
	text:     [16]i8,
	text_len: i32,
}

input :: struct {
	keyboard: keyboard,
	mouse:    mouse,
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	input_has_mouse_click                            :: proc(^input, buttons) -> bool ---
	input_has_mouse_click_in_rect                    :: proc(^input, buttons, rect) -> bool ---
	input_has_mouse_click_in_button_rect             :: proc(^input, buttons, rect) -> bool ---
	input_has_mouse_click_down_in_rect               :: proc(_: ^input, _: buttons, _: rect, down: bool) -> bool ---
	input_is_mouse_click_in_rect                     :: proc(^input, buttons, rect) -> bool ---
	input_is_mouse_click_down_in_rect                :: proc(i: ^input, id: buttons, b: rect, down: bool) -> bool ---
	input_any_mouse_click_in_rect                    :: proc(^input, rect) -> bool ---
	input_is_mouse_prev_hovering_rect                :: proc(^input, rect) -> bool ---
	input_is_mouse_hovering_rect                     :: proc(^input, rect) -> bool ---
	input_is_mouse_hovering_still_rect               :: proc(^input, rect) -> bool ---
	input_is_mouse_hovering_delay_rect               :: proc(^context, rect, ^f32, f32) -> bool ---
	input_is_mouse_hovering_still_delay_rect         :: proc(^context, rect, ^f32, f32) -> bool ---
	input_is_mouse_hovering_still_delay_clicked_rect :: proc(^context, rect, ^f32, f32, ^bool) -> bool ---
	input_is_mouse_moved                             :: proc(^input) -> bool ---
	input_mouse_clicked                              :: proc(^input, buttons, rect) -> bool ---
	input_is_mouse_down                              :: proc(^input, buttons) -> bool ---
	input_is_mouse_pressed                           :: proc(^input, buttons) -> bool ---
	input_is_mouse_released                          :: proc(^input, buttons) -> bool ---
	input_is_key_pressed                             :: proc(^input, keys) -> bool ---
	input_is_key_released                            :: proc(^input, keys) -> bool ---
	input_is_key_down                                :: proc(^input, keys) -> bool ---
}

/* ===============================================================
*
*                          GUI
*
* ===============================================================*/
style_item_type :: enum u32 {
	COLOR      = 0,
	IMAGE      = 1,
	NINE_SLICE = 2,
}

style_item_data :: struct #raw_union {
	color: color,
	image: image,
	slice: nine_slice,
}

style_item :: struct {}

style_text :: struct {
	color:           color,
	padding:         vec2,
	color_factor:    f32,
	disabled_factor: f32,
}

style_button     :: struct {}
style_toggle     :: struct {}
style_selectable :: struct {}

style_slider :: struct {
	/* background */
	normal:       style_item,
	hover:        style_item,
	active:       style_item,
	border_color: color,

	/* background bar */
	bar_normal: color,
	bar_hover:  color,
	bar_active: color,
	bar_filled: color,

	/* cursor */
	cursor_normal: style_item,
	cursor_hover:  style_item,
	cursor_active: style_item,

	/* properties */
	border:          f32,
	rounding:        f32,
	bar_height:      f32,
	padding:         vec2,
	spacing:         vec2,
	cursor_size:     vec2, /* NOTE y has no effect on vertex buffer backends */
	color_factor:    f32,
	disabled_factor: f32,

	/* optional buttons */
	show_buttons: i32,
	inc_button:   style_button,
	dec_button:   style_button,
	inc_symbol:   symbol_type,
	dec_symbol:   symbol_type,

	/* optional user callbacks */
	userdata:   handle,
	draw_begin: proc "c" (^command_buffer, handle),
	draw_end:   proc "c" (^command_buffer, handle),
}

style_knob :: struct {
	/* background */
	normal:       style_item,
	hover:        style_item,
	active:       style_item,
	border_color: color,

	/* knob */
	knob_normal:       color,
	knob_hover:        color,
	knob_active:       color,
	knob_border_color: color,

	/* cursor */
	cursor_normal: color,
	cursor_hover:  color,
	cursor_active: color,

	/* properties */
	border:          f32,
	knob_border:     f32,
	padding:         vec2,
	spacing:         vec2,
	cursor_width:    f32,
	color_factor:    f32,
	disabled_factor: f32,

	/* optional user callbacks */
	userdata:   handle,
	draw_begin: proc "c" (^command_buffer, handle),
	draw_end:   proc "c" (^command_buffer, handle),
}

style_progress  :: struct {}
style_scrollbar :: struct {}
style_edit      :: struct {}
style_property  :: struct {}
style_chart     :: struct {}
style_combo     :: struct {}
style_tab       :: struct {}

style_header_align :: enum u32 {
	LEFT  = 0,
	RIGHT = 1,
}

style_window_header :: struct {}
style_window        :: struct {}

style :: struct {
	font:              ^user_font,
	cursors:           [7]^cursor,
	cursor_active:     ^cursor,
	cursor_last:       ^cursor,
	cursor_visible:    i32,
	text:              style_text,
	button:            style_button,
	contextual_button: style_button,
	menu_button:       style_button,
	option:            style_toggle,
	checkbox:          style_toggle,
	selectable:        style_selectable,
	slider:            style_slider,
	knob:              style_knob,
	progress:          style_progress,
	property:          style_property,
	edit:              style_edit,
	chart:             style_chart,
	scrollh:           style_scrollbar,
	scrollv:           style_scrollbar,
	tab:               style_tab,
	combo:             style_combo,
	window:            style_window,
}

@(default_calling_convention="c", link_prefix="nk_")
foreign lib {
	style_item_color      :: proc(color) -> style_item ---
	style_item_image      :: proc(img: image) -> style_item ---
	style_item_nine_slice :: proc(slice: nine_slice) -> style_item ---
	style_item_hide       :: proc() -> style_item ---
}

MAX_LAYOUT_ROW_TEMPLATE_COLUMNS :: 16
CHART_MAX_SLOT                  :: 4

panel_type :: enum u32 {
	NONE       = 0,
	WINDOW     = 1,
	GROUP      = 2,
	POPUP      = 4,
	CONTEXTUAL = 16,
	COMBO      = 32,
	MENU       = 64,
	TOOLTIP    = 128,
}

panel_set :: enum u32 {
	NONBLOCK = 240,
	POPUP    = 244,
	SUB      = 246,
}

chart_slot :: struct {
	type:            chart_type,
	color:           color,
	highlight:       color,
	min, max, range: f32,
	count:           i32,
	last:            vec2,
	index:           i32,
	show_markers:    bool,
}

chart :: struct {
	slot:       i32,
	x, y, w, h: f32,
	slots:      [4]chart_slot,
}

panel_row_layout_type :: enum u32 {
	DYNAMIC_FIXED = 0,
	DYNAMIC_ROW   = 1,
	DYNAMIC_FREE  = 2,
	DYNAMIC       = 3,
	STATIC_FIXED  = 4,
	STATIC_ROW    = 5,
	STATIC_FREE   = 6,
	STATIC        = 7,
	TEMPLATE      = 8,
}

row_layout :: struct {
	type:        panel_row_layout_type,
	index:       i32,
	height:      f32,
	min_height:  f32,
	columns:     i32,
	ratio:       ^f32,
	item_width:  f32,
	item_height: f32,
	item_offset: f32,
	filled:      f32,
	item:        rect,
	tree_depth:  i32,
	templates:   [16]f32,
}

popup_buffer :: struct {
	begin:  uint,
	parent: uint,
	last:   uint,
	end:    uint,
	active: bool,
}

menu_state :: struct {
	x, y, w, h: f32,
	offset:     scroll,
}

panel :: struct {}

WINDOW_MAX_NAME :: 64

window_flags :: enum u32 {
	PRIVATE         = 2048,
	DYNAMIC         = 2048,  /**< special window type growing up in height while being filled to a certain maximum height */
	ROM             = 4096,  /**< sets window widgets into a read only mode and does not allow input changes */
	NOT_INTERACTIVE = 5120,  /**< prevents all interaction caused by input to either window or widgets inside */
	HIDDEN          = 8192,  /**< Hides window and stops any window interaction and drawing */
	CLOSED          = 16384, /**< Directly closes and frees the window at the end of the frame */
	MINIMIZED       = 32768, /**< marks the window as minimized */
	REMOVE_ROM      = 65536, /**< Removes read only mode at the end of the window */
}

popup_state :: struct {
	win:                ^window,
	type:               panel_type,
	buf:                popup_buffer,
	name:               Hash,
	active:             bool,
	combo_count:        u32,
	con_count, con_old: u32,
	active_con:         u32,
	header:             rect,
}

edit_state :: struct {
	name:         Hash,
	seq:          u32,
	old:          u32,
	active, prev: i32,
	cursor:       i32,
	sel_start:    i32,
	sel_end:      i32,
	scrollbar:    scroll,
	mode:         u8,
	single_line:  u8,
}

property_state :: struct {
	active, prev: i32,
	buffer:       [64]i8,
	length:       i32,
	cursor:       i32,
	select_start: i32,
	select_end:   i32,
	name:         Hash,
	seq:          u32,
	old:          u32,
	state:        i32,
	prev_state:   i32,
	prev_name:    Hash,
	prev_buffer:  [64]i8,
	prev_length:  i32,
}

window :: struct {}

BUTTON_BEHAVIOR_STACK_SIZE :: 8
FONT_STACK_SIZE            :: 8
STYLE_ITEM_STACK_SIZE      :: 16
FLOAT_STACK_SIZE           :: 32
VECTOR_STACK_SIZE          :: 16
FLAGS_STACK_SIZE           :: 32
COLOR_STACK_SIZE           :: 32

config_stack_style_item_element :: struct {
	address:   ^style_item,
	old_value: style_item,
}

config_stack_float_element :: struct {
	address:   ^f32,
	old_value: f32,
}

config_stack_vec2_element :: struct {
	address:   ^vec2,
	old_value: vec2,
}

config_stack_flags_element :: struct {
	address:   ^Flags,
	old_value: Flags,
}

config_stack_color_element :: struct {
	address:   ^color,
	old_value: color,
}

config_stack_user_font_element :: struct {
	address:   ^^user_font,
	old_value: ^user_font,
}

config_stack_button_behavior_element :: struct {
	address:   ^button_behavior,
	old_value: button_behavior,
}

config_stack_style_item :: struct {
	head:     i32,
	elements: [16]config_stack_style_item_element,
}

config_stack_float :: struct {
	head:     i32,
	elements: [32]config_stack_float_element,
}

config_stack_vec2 :: struct {
	head:     i32,
	elements: [16]config_stack_vec2_element,
}

config_stack_flags :: struct {
	head:     i32,
	elements: [32]config_stack_flags_element,
}

config_stack_color :: struct {
	head:     i32,
	elements: [32]config_stack_color_element,
}

config_stack_user_font :: struct {
	head:     i32,
	elements: [8]config_stack_user_font_element,
}

config_stack_button_behavior :: struct {
	head:     i32,
	elements: [8]config_stack_button_behavior_element,
}

configuration_stacks :: struct {
	style_items:      config_stack_style_item,
	floats:           config_stack_float,
	vectors:          config_stack_vec2,
	flags:            config_stack_flags,
	colors:           config_stack_color,
	fonts:            config_stack_user_font,
	button_behaviors: config_stack_button_behavior,
}

table :: struct {}

page_data :: struct #raw_union {
	tbl: table,
	pan: panel,
	win: window,
}

page_element :: struct {
	data: page_data,
	next: ^page_element,
	prev: ^page_element,
}

page :: struct {
	size: u32,
	next: ^page,
	win:  [1]page_element,
}

pool :: struct {
	alloc:      allocator,
	type:       allocation_type,
	page_count: u32,
	pages:      ^page,
	freelist:   ^page_element,
	capacity:   u32,
	size:       uint,
	cap:        uint,
}

context :: struct {}

/* ==============================================================
*                          MATH
* =============================================================== */
PI                  :: 3.141592654
PI_HALF             :: 1.570796326
MAX_FLOAT_PRECISION :: 2

