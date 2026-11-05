import unittest
from unittest.mock import patch
from lg.vision import action4_camera_index

class Action4Selection(unittest.TestCase):
    def tearDown(self):
        action4_camera_index.cache_clear()

    def test_selects_name_even_when_phone_has_index_one(self):
        action4_camera_index.cache_clear()
        with patch('subprocess.check_output',return_value='[{"index":1,"name":"iPhone"},{"index":2,"name":"OsmoAction4"}]'):
            self.assertEqual(action4_camera_index(),2)

    def test_missing_action4_never_falls_back_to_phone(self):
        action4_camera_index.cache_clear()
        with patch('subprocess.check_output',return_value='[{"index":1,"name":"iPhone"}]'):
            with self.assertRaisesRegex(RuntimeError,'OsmoAction4'):
                action4_camera_index()
