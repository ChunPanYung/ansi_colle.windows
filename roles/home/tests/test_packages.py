import pytest

@pytest.fixture(scope='module')
def hostname(host):
    return host.ansible.get_variables()['inventory_hostname']

def test_hostname(host, hostname):
    assert host.check_output('hostname -s')
