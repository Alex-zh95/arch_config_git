'''
Uses the free, open-source ipify API: (https://www.ipify.org) to retrieve public IP address
for geolocation purposes (e.g. live update of weather or clocks).
'''

import requests


def get_ip() -> str:
    ''' Returns the public IP address in plaintext form. '''
    return requests.get('https://api.ipify.org').text


def poll_wttr() -> str:
    '''
    Returns current weather string from wttr.in (current location).

    Wttr docs: https://github.com/chubin/wttr.in
    '''

    # Initial text
    out = ''

    try:
        out = requests.get('https://v2n.wttr.in/?format=%c%t %w&lang=de?T', timeout=10).text
    except (requests.exceptions.Timeout | ConnectionError | requests.exceptions.TooManyRedirects | requests.exceptions.RequestException):
        out = ''
    finally:
        if (out == '') | ('we will get new queries as soon as possible' in out.lower()):
            out = ''

    return out
