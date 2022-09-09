/*
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "music.h"

#define Y(E) (523 * 50 + (E) / 2) / (E)

#define C (523 * 50 + (262) / 2) / (262)
#define D (523 * 50 + (294) / 2) / (294)
#define E (523 * 50 + (330) / 2) / (330)
#define F (523 * 50 + (349) / 2) / (349)
#define G (523 * 50 + (392) / 2) / (392)
#define A (523 * 50 + (440) / 2) / (440)
#define C2 (523 * 50 + (523) / 2) / (523)

#define M(N, X) (N), (uint32_t)(X)*6000

uint16_t music[69] = {M(F, 8), M(A, 4),  M(C2, 4), M(A, 4), M(F, 8), M(C, 4),  M(D, 4),  M(E, 4), M(F, 8),
                      M(A, 4), M(C2, 4), M(A, 4),  M(G, 8), M(C, 4), M(D, 4),  M(E, 4),  M(E, 8), M(C, 4),
                      M(D, 4), M(E, 4),  M(F, 16), M(F, 8), M(A, 4), M(C2, 4), M(A, 4),  M(G, 8), M(C, 4),
                      M(D, 4), M(E, 4),  M(E, 8),  M(C, 4), M(D, 4), M(E, 4),  M(F, 16), 0};
