extends Node


#player animation
const ANIMATION_CATCH_BREATH = "Catch breath"
const ANIMATION_FALL = "Fall"
const ANIMATION_JUMP = "Jump"
const ANIMATION_LAND = "Land"
const ANIMATION_LIFT_OFF = "Lift off"
const ANIMATION_RAISE = "Raise"
const ANIMATION_RECOVER = "Recover"
const ANIMATION_RUN = "Run"

#player states
const STATE_CATCHING_BREATH = "Catching breath"
const STATE_FALLING = "Falling"
const STATE_JUMPING = "Jumping"
const STATE_LANDING = "Landing"
const STATE_LIFTING_OFF = "Lifting off"
const STATE_RAISING = "Raising"
const STATE_RECOVERING = "Recovering"
const STATE_RUNNING = "Running"

#states parameters
const STATE_PARAM_ANIMATION = "animation"
const STATE_PARAM_COLLISION = "collision"
const STATE_PARAM_FINAL_ON_GAME_OVER = "final on game over"
const STATE_PARAM_FRAMERATE_FIXED = "framerate fixed"
const STATE_PARAM_NEXT = "next state"
const STATE_PARAM_TRANSITION = "transition"
const STATE_PARAM_ALLOW_ACTION = "allow action"
const STATE_PARAM_SPEED_FACTOR = "speed factor"

#display data
const DISPLAY_DISTANCE_FORMAT = "%.1f %s"
const DISPLAY_DISTANCE_UNIT = "m"
const DISPLAY_DISTANCE_UNIT_FULL = "meters"
const GAME_OVER_MESSAGE = "you ran for %.1f %s!"
