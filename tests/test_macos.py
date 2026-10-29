"""Platform boundaries: camera backend and explicit inference overrides."""
import os
import unittest
from unittest.mock import patch, MagicMock
import cv2
import numpy as np
from lg.vision import open_camera, cuda_device, prepare_camera

class PlatformTests(unittest.TestCase):
    def tearDown(self):
        cuda_device.cache_clear()

    def test_native_camera_backend_per_platform(self):
        for platform, backend in [('darwin', cv2.CAP_AVFOUNDATION), ('win32', cv2.CAP_DSHOW), ('linux', cv2.CAP_ANY)]:
            with self.subTest(platform=platform):
                capture = MagicMock()
                capture.read.return_value = (True, np.zeros((8,8,3), np.uint8))
                with patch('lg.vision.sys.platform', platform), patch('lg.vision.cv2.VideoCapture', return_value=capture) as factory:
                    open_camera('0')
                factory.assert_called_once_with(0, backend)
                mjpg = unittest.mock.call.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*'MJPG'))
                self.assertEqual(mjpg in capture.mock_calls, platform == 'win32')

    def test_cpu_override(self):
        cuda_device.cache_clear()
        with patch.dict(os.environ, {'YTO_DEVICE': 'cpu'}):
            self.assertEqual(cuda_device(), 'cpu')

    def test_invalid_device_fails_clearly(self):
        cuda_device.cache_clear()
        with patch.dict(os.environ, {'YTO_DEVICE': 'invalid'}):
            with self.assertRaisesRegex(ValueError, 'YTO_DEVICE'):
                cuda_device()

    def test_permission_preflight_only_for_macos_cameras(self):
        for platform, source, expected in [('darwin','0',True),('darwin','auto',True),('darwin','movie.mp4',False),('win32','0',False)]:
            with self.subTest(platform=platform,source=source):
                capture=MagicMock()
                with patch('lg.vision.sys.platform',platform), patch('lg.vision.open_camera',return_value=(capture,None,0)) as camera:
                    prepare_camera(source)
                self.assertEqual(camera.called,expected)
                self.assertEqual(capture.release.called,expected)
