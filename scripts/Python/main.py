from datetime import datetime
import json
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
import logging
from netmiko import ConnectHandler, NetmikoAuthenticationException, NetMikoTimeoutException

def command_func(device_dict, show):
    '''
    Connects to switch and executes command
    :param device_dict: Dictionary with parameters for connection to switch
    :param show: Executable command on switch
    :return: Successful connection to switch or not successful
    '''
    start_msg = '===> {} Connection: {}'
    received_msg = '<=== {} Received: {}'
    ip = device_dict['ip']
    logging.info(start_msg.format(datetime.now().time(), ip))

    try:
        with ConnectHandler(**device_dict) as ssh:
            result = ssh.send_command(show)
            logging.info(received_msg.format(datetime.now().time(), ip))
        return {ip: result}
    except NetmikoAuthenticationException:
        result = 'Authentication err'
        return {ip: result}
        logging.warning('Authentication exception')
    except NetMikoTimeoutException:
        result = 'Connection error'
        return {ip: result}
        logging.warning('Switch is not avaible')

def show_result(results):
    '''
    :param results:
    :return:
    '''
    for result in results:
        for key, value in result.items():
            print(key + ': ' + value)

def send_command(devices, comm):
    '''
    For executing multithreading connection to several switch simulate.
    :param devices: 
    :param comm:
    :return:
    '''
    results = []
    with ThreadPoolExecutor(max_workers=3) as executor:
        future_list = []
        for device in devices:
            future = executor.submit(command_func, device, comm)
            future_list.append(future)
        for f in as_completed(future_list):
            results.append((f.result()))
    show_result(results)


#Create logging info
logging.getLogger('paramiko').setLevel(logging.WARNING)
logging.basicConfig(
    format='%(threadName)s %(name)s %(levelname)s: %(message)s',
    level=logging.INFO)

with open('devices.json') as f:
     devices = json.load(f)

begin_time = datetime.now()

#Sending command to the switches
send_command(devices)

time_exec = datetime.now() - begin_time
print('Time of execution: ' + str(time_exec))



#Change ipaddress for logserver
#'config syslog host 1 severity warning facility local0 state enable ipaddress 192.168.0.198'
#exec_command(command='show switch')
#save_cfg()




