import unittest
from unittest.mock import patch
import numpy as np
from lg.core import Hand
from lg.vision import draw

class SkeletonColors(unittest.TestCase):
    def test_anatomical_colors_independent_of_screen_order(self):
        points=np.zeros((21,3),np.float32)
        hands=[Hand(points,None,(0,0,1,1),handedness='Right'),
               Hand(points,None,(0,0,1,1),handedness='Left')]
        with patch('lg.vision.cv2.line') as line, patch('lg.vision.cv2.circle') as circle:
            draw(np.zeros((50,50,3),np.uint8),hands)
        self.assertEqual(line.call_args_list[0].args[3:5],((0,255,0),4))
        self.assertEqual(line.call_args_list[-1].args[3:5],((255,0,0),4))
        self.assertEqual(circle.call_args_list[0].args[3],(255,0,0))
        self.assertEqual(circle.call_args_list[-1].args[3],(0,255,0))
