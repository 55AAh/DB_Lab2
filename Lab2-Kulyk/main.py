from db import Db
from flyway import Flyway


def main():
    fw = Flyway()
    db = Db(fw.auth)
    db.generate_v_1_0_sql(fw)
    db.generate_v_1_1_sql(fw)
    db.generate_v_1_2_sql(fw)
    db.generate_v_1_3_sql(fw)
    db.generate_v_1_4_sql(fw)
    #db.generate_v_1_5_sql(fw)
    #db.generate_v_1_6_sql(fw)
    #fw.handle_state(db)


if __name__ == "__main__":
    main()
