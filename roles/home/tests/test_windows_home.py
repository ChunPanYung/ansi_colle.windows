#!/usr/bin/env python3
import pytest
from testinfra.host import Host

@pytest.mark.windows
@pytest.mark.home
class TestHomeConfig:
    def test_sys_info(self, host: Host):
        assert host.system_info.type == 'windows'

    def test_dir(self, host: Host):
        assert host.file(r"C:/Users").exists
        assert host.file("C:/Windows/Temp").listdir()

    # def test_ansible_mod(self, host: Host):
    #     assert host.ansible(
    #         "ansible.windows.win_command", "echo foo", check=False
    #     )["stdout"] == 'foo'
