let baseX = 2
let baseY = 2
let baseZ = 2

// Tower 1 (Higher)
blocks.fill(
    COBBLESTONE,
    pos(baseX, baseY, baseZ),
    pos(baseX + 2, baseY + 9, baseZ + 2), // 3x3, height 10
    FillOperation.Replace
)

// wall 1
blocks.fill(
    STONE,
    pos(baseX + 3, baseY, baseZ),
    pos(baseX + 12, baseY + 4, baseZ + 2), // length 10, heght 5
    FillOperation.Replace
)

// Tower 2
blocks.fill(
    COBBLESTONE,
    pos(baseX + 13, baseY, baseZ),
    pos(baseX + 15, baseY + 6, baseZ + 2), // 3x3, height 7
    FillOperation.Replace
)

// wall 2
blocks.fill(
    STONE,
    pos(baseX + 3, baseY, baseZ + 13),
    pos(baseX + 12, baseY + 4, baseZ + 15), // length 10, height 5
    FillOperation.Replace
)

// Tower 3
blocks.fill(
    COBBLESTONE,
    pos(baseX, baseY, baseZ + 13),
    pos(baseX + 2, baseY + 6, baseZ + 15), // 3x3, height 7
    FillOperation.Replace
)

// wall 3
blocks.fill(
    STONE,
    pos(baseX, baseY, baseZ + 3),
    pos(baseX + 2, baseY + 4, baseZ + 12), // length 10, height 5
    FillOperation.Replace
)

// wall 4
blocks.fill(
    STONE,
    pos(baseX + 13, baseY, baseZ + 3),
    pos(baseX + 15, baseY + 4, baseZ + 12), // length 10, height 5
    FillOperation.Replace
)

// Tower 4
blocks.fill(
    COBBLESTONE,
    pos(baseX + 13, baseY, baseZ + 13),
    pos(baseX + 15, baseY + 6, baseZ + 15), // 3x3, height 7
    FillOperation.Replace
)

// Roofs
let roofX1 = baseX - 1
let roofY1 = baseY + 10
let roofZ1 = baseZ - 1
let size1 = 5
for (let i = 0; i < 3; i++) {
    blocks.fill(
        PLANKS_OAK,
        pos(roofX1 + i, roofY1 + i, roofZ1 + i),
        pos(roofX1 + size1 - 1 - i, roofY1 + i, roofZ1 + size1 - 1 - i),
        FillOperation.Replace
    )
}

let roofX2 = baseX + 12
let roofY2 = baseY + 7
let roofZ2 = baseZ - 1
let size2 = 5
for (let i = 0; i < 3; i++) {
    blocks.fill(
        PLANKS_OAK,
        pos(roofX2 + i, roofY2 + i, roofZ2 + i),
        pos(roofX2 + size2 - 1 - i, roofY2 + i, roofZ2 + size2 - 1 - i),
        FillOperation.Replace
    )
}

let roofX3 = baseX - 1
let roofY3 = baseY + 7
let roofZ3 = baseZ + 12
let size3 = 5
for (let i = 0; i < 3; i++) {
    blocks.fill(
        PLANKS_OAK,
        pos(roofX3 + i, roofY3 + i, roofZ3 + i),
        pos(roofX3 + size3 - 1 - i, roofY3 + i, roofZ3 + size3 - 1 - i),
        FillOperation.Replace
    )
}

let roofX4 = baseX + 12
let roofY4 = baseY + 7
let roofZ4 = baseZ + 12
let size4 = 5
for (let i = 0; i < 3; i++) {
    blocks.fill(
        PLANKS_OAK,
        pos(roofX4 + i, roofY4 + i, roofZ4 + i),
        pos(roofX4 + size4 - 1 - i, roofY4 + i, roofZ4 + size4 - 1 - i),
        FillOperation.Replace
    )
}

let doorXStart = baseX + 6
let doorXEnd = baseX + 8
let doorYStart = baseY
let doorYEnd = baseY + 5
let doorZ = baseZ  // front wall

// Big wooden door
blocks.fill(
    PLANKS_DARK_OAK,
    pos(doorXStart, doorYStart, doorZ),
    pos(doorXEnd, doorYEnd, doorZ),
    FillOperation.Replace
)

blocks.fill(
    OAK_FENCE,
    pos(baseX + 3, baseY + 5, baseZ),
    pos(baseX + 12, baseY + 5, baseZ + 2),
    FillOperation.Replace
)

// Fences
blocks.fill(
    OAK_FENCE,
    pos(baseX + 3, baseY + 5, baseZ + 13),
    pos(baseX + 12, baseY + 5, baseZ + 15),
    FillOperation.Replace
)

blocks.fill(
    OAK_FENCE,
    pos(baseX, baseY + 5, baseZ + 3),
    pos(baseX + 2, baseY + 5, baseZ + 12),
    FillOperation.Replace
)

blocks.fill(
    OAK_FENCE,
    pos(baseX + 13, baseY + 5, baseZ + 3),
    pos(baseX + 15, baseY + 5, baseZ + 12),
    FillOperation.Replace
)

blocks.place(
    GLOWSTONE,
    pos(doorXStart - 1, doorYStart + 2, doorZ)
)

blocks.place(
    GLOWSTONE,
    pos(doorXEnd + 1, doorYStart + 2, doorZ)
)

// Glowstones
blocks.place(
    GLOWSTONE,
    pos(roofX1 + 2, roofY1 + 3, roofZ1 + 2)
)

// Wieża 2
blocks.place(
    GLOWSTONE,
    pos(roofX2 + 2, roofY2 + 3, roofZ2 + 2)
)

// Wieża 3
blocks.place(
    GLOWSTONE,
    pos(roofX3 + 2, roofY3 + 3, roofZ3 + 2)
)

// Wieża 4
blocks.place(
    GLOWSTONE,
    pos(roofX4 + 2, roofY4 + 3, roofZ4 + 2)
)

// Wall windows
blocks.fill(
    GLASS,
    pos(baseX + 5, baseY + 4, baseZ),
    pos(baseX + 6, baseY + 5, baseZ),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 9, baseY + 4, baseZ),
    pos(baseX + 10, baseY + 5, baseZ),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 5, baseY + 2, baseZ + 15),
    pos(baseX + 6, baseY + 3, baseZ + 15),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 9, baseY + 2, baseZ + 15),
    pos(baseX + 10, baseY + 3, baseZ + 15),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX, baseY + 2, baseZ + 5),
    pos(baseX, baseY + 3, baseZ + 6),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX, baseY + 2, baseZ + 9),
    pos(baseX, baseY + 3, baseZ + 10),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 15, baseY + 2, baseZ + 5),
    pos(baseX + 15, baseY + 3, baseZ + 6),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 15, baseY + 2, baseZ + 9),
    pos(baseX + 15, baseY + 3, baseZ + 10),
    FillOperation.Replace
)

// Tower Windows
blocks.fill(
    GLASS,
    pos(baseX + 1, baseY + 4, baseZ),
    pos(baseX + 1, baseY + 5, baseZ),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 14, baseY + 3, baseZ),
    pos(baseX + 14, baseY + 4, baseZ),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 1, baseY + 3, baseZ + 15),
    pos(baseX + 1, baseY + 4, baseZ + 15),
    FillOperation.Replace
)

blocks.fill(
    GLASS,
    pos(baseX + 14, baseY + 3, baseZ + 15),
    pos(baseX + 14, baseY + 4, baseZ + 15),
    FillOperation.Replace
)