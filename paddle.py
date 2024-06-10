#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 29 10:59:41 2023

@author: krk
"""

from turtle import Turtle


class Paddle(Turtle):

    def __init__(self, posX, posY):
        super().__init__()
        self.color("white")
        self.shape("square")
        self.shapesize(stretch_len=0.5, stretch_wid=5)
        self.penup()
        self.goto(posX, posY)


    def move_up(self):
        if self.ycor() <=230:
            new_y = self.ycor() + 20
            self.goto(self.xcor(), new_y)

    def move_down(self):
        if self.ycor() >=-230:
            new_y = self.ycor() - 20
            self.goto(self.xcor(), new_y)

