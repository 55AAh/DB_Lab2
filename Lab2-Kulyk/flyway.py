import sys
import os
import subprocess


class Flyway:
    def __init__(self):
        print("Reading flyway.conf... ", flush=True, end='')
        p = dict()
        with open("flyway.conf") as f:
            for l in f.readlines():
                pt = l.strip().split('=')
                if len(pt) == 2:
                    pn, pv = pt
                    p[pn] = pv
        self.auth = dict(dbname=p["flyway.url"].split('/')[-1],
                    user=p["flyway.user"],
                    password=p["flyway.password"])
        print("done", flush=True)

    def get_state(self):
        sv = subprocess.check_output('flyway info', shell=True).decode("utf-8")\
             .split("Schema version: ")[1].split('\n')[0].strip()
        if sv == "<< Empty Schema >>":
            return "empty"
        if sv == "1.0":
            return sv
    
    def handle_state(self, db):
        print("Flyway migration state: ", flush=True, end='')
        state = self.get_state()
        print(state, flush=True)
        if state == "empty":
            self.create_baseline()
            state = "1.0"
        if state == "1.0":
            print("ok")
    
    def create_baseline(self):
        print("Creating baseline... ", flush=True, end='')
        o = subprocess.check_output('flyway -baselineVersion="0.0" baseline', shell=True).decode("utf-8")
        if "Successfully baselined schema with version: 0.0" not in o:
            print("error!")
            sys.exit(1)
        print("done", flush=True)
    
    def write_sql_migration(self, script, version, name):
        fn = f"V{version}__{name}.sql"
        if not os.path.exists("sql"):
            os.makedirs("sql")
        with open(os.path.join("sql", fn), "w") as f:
            f.write(script)
    
    def migrate(self):
        subprocess.run('flyway migrate', shell=True)
