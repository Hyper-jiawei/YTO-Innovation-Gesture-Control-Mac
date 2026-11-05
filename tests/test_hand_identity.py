import unittest
from lg.core import physical_handedness
class HandIdentity(unittest.TestCase):
    def test_no_duplicate_left_right_swap(self):
        self.assertEqual(physical_handedness('Left'),'Left')
        self.assertEqual(physical_handedness('Right'),'Right')
        self.assertIsNone(physical_handedness('unknown'))
