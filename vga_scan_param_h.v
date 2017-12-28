// setting brief:
//	initial canvas size: 480 * 600
//	grouped into pixel unit
//	eg. 4*4 unit make 480 * 600 canvas a 120 * 150 canvas
// current setting: 8*8 unit; 60*80 canvas

// col addr width (2^7 > 80)
`define COL_WIDTH 7
// row addr width (2^6 > 60)
`define ROW_WIDTH 6
// the middle col axis of canvas
`define COL_MID 29
// the middle row axis of canvas
`define ROW_MID 39
// col edge size
`define COL_EDGE 0 
// row edge size
`define ROW_EDGE 0
// the mosaic unit size
`define UNIT_WIDTH 3