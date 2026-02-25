/**
 * AETHER PRIME - STEP 2: HIGH-FIDELITY SPATIAL STRUGGLE
 * Architect: Adam Parszewski
 * Goal: Document the space/thermal constraints of a flat PCB layout.
 */

$fn = 32;

// --- HIGH FIDELITY COMPONENT LIBRARY ---

module chip_bga(size_x, size_y, height, label) {
    union() {
        color("DimGray") cube([size_x, size_y, height-0.5], center=true); // Body
        color("Silver") translate([0,0,height/2 - 0.25]) cube([size_x-4, size_y-4, 0.5], center=true); // Heat spreader
        // BGA Balls visualization
        color("LightGray")
        for(i=[-size_x/2+2 : 4 : size_x/2-2], j=[-size_y/2+2 : 4 : size_y/2-2])
            translate([i, j, -height/2]) sphere(r=0.4);
    }
}

module usb_c_port() {
    color("Silver") {
        difference() {
            cube([9, 12, 4.5], center=true); // Metal shell
            translate([1, 0, 0]) cube([8, 10, 3.5], center=true); // Inner cavity
        }
    }
    color("Black") translate([0.5, 0, 0]) cube([7, 9, 1], center=true); // Plastic tongue
}

module rj45_port() {
    color("Silver") cube([16, 15, 13], center=true); // Shielded housing
    translate([2, 0, -2]) color("Black") cube([14, 12, 10], center=true); // Connector cavity
}

module ram_lpddr5() {
    color("#1a1a1a") {
        cube([12, 10, 1.2], center=true);
        translate([0,0,0.6]) color("White", 0.2) cube([10, 8, 0.1], center=true);
    }
}

module nvme_ssd() {
    // Socket
    color("DimGray") translate([-35, 0, 0]) cube([10, 22, 5], center=true);
    // SSD Board
    color("#003300") translate([0, 0, 2]) cube([80, 22, 1.5], center=true);
    // Flash Chips
    for(i=[-15, 10]) translate([i, 0, 3]) color("Black") cube([15, 18, 1.5], center=true);
}

// --- MAIN ASSEMBLY: THE STRUGGLE ---

// Base PCB (Limited by standard form factors)
color("DarkGreen", 0.8) translate([0,0,-1]) cube([100, 100, 1.6], center=true);

// Placing the massive RK3588
translate([0, 0, 1]) chip_bga(23, 23, 2.5, "RK3588");

// RAM - Attempting Quad Channel around SoC
translate([22, 0, 1]) ram_lpddr5();
translate([-22, 0, 1]) ram_lpddr5();
translate([0, 22, 1]) rotate([0,0,90]) ram_lpddr5();
translate([0, -22, 1]) rotate([0,0,90]) ram_lpddr5();

// I/O Ports - They take too much edge space!
translate([45, 30, 2.25]) rotate([0,0,90]) usb_c_port();
translate([45, 15, 2.25]) rotate([0,0,90]) usb_c_port();
translate([45, -10, 6.5]) rotate([0,0,90]) rj45_port();

// NVMe - Nachodzi na RAM! (This shows the conflict)
translate([-10, -40, 1]) rotate([0,0,0]) nvme_ssd();

// Annotation of the conflict
%translate([-20, -35, 10]) color("Red", 0.3) cube([40, 40, 5], center=true);
