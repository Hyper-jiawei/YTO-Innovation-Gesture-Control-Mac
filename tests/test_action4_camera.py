import unittest
from lg.vision import preferred_camera_device

class CameraPriority(unittest.TestCase):
    def test_action4_wins_even_if_phone_first(self):
        self.assertEqual(preferred_camera_device([{'index':1,'name':'iPhone'},{'index':0,'name':'OsmoAction4'}])['index'],0)
    def test_phone_backup_without_action4(self):
        self.assertEqual(preferred_camera_device([{'index':0,'name':'FaceTime'},{'index':1,'name':'Hyper的相机'}])['index'],1)
    def test_no_device_reports_error(self):
        with self.assertRaises(RuntimeError):preferred_camera_device([])
