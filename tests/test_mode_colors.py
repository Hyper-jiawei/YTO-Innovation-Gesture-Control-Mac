import unittest
from lg.ui import mode_colors, ACCENT

class ModeColors(unittest.TestCase):
    def test_unselected(self):
        colors=mode_colors(False)
        self.assertEqual((colors['bg'],colors['fg'],colors['highlightbackground']),('#ffffff','#000000',ACCENT))
    def test_selected(self):
        colors=mode_colors(True)
        self.assertEqual((colors['bg'],colors['fg'],colors['highlightbackground']),(ACCENT,'#ffffff','#000000'))
