BEGIN TRANSACTION;

Drop table if exists member, interest_group, interest_group_member, event, event_member cascade;

CREATE table member
(
    member_number          serial       not null,
    last_name              varchar(255) not null,
    first_name             varchar(255) not null,
    email_address          varchar(255) not null,
    phone_number           varchar(11)  null,
    date_of_birth          date         not null,
    reminder_email_boolean boolean      not null,
    constraint PK_member_number primary key (member_number)
);

create table interest_group
(
    group_number serial       not null,
    name         varchar(255) not null,
    constraint PK_ig_group_number primary key (group_number),
    constraint UQ_name unique (name)
);

create table interest_group_member
(
    member_number integer not null,
    group_number  integer not null,
    constraint PK_igm_member_num primary key (member_number, group_number)

);

create table event
(
    event_number        serial       not null,
    event_name          varchar(255) not null,
    description         text         not null,
    start_date_and_time timestamp    not null,
    duration            integer      not null,
    event_organizer     varchar(255) not null,
    constraint PK_event_number primary key (event_number),
    constraint CHK_event_duration check ( duration >= 30 )
);

create table event_member
(
    event_number  integer not null,
    member_number integer not null,
    constraint PK_em_event_number primary key (event_number, member_number)
);



insert into member(last_name, first_name, email_address, date_of_birth, reminder_email_boolean)
values ('Kotula', 'Daniel', 'kotula.daniel@gmail.com', '01/01/2000', true),
       ('Bajgain', 'Phajindra', 'p.bajgain@gmail.com', '02/02/1990', true),
       ('Walter', 'Azeb', 'azeb@gmail.com', '02/02/1987', true),
       ('Love', 'David', 'love.david@gmail.com', '11/02/1980', false),
       ('Smith', 'Tom', 'smith.tom@gmail.com', '12/11/1970', true);
insert into member(last_name, first_name, email_address, phone_number, date_of_birth, reminder_email_boolean)
values ('Brooks', 'William', 'willam.brooks@gmail.com', '2156798855', '09/22/1993', false),
       ('Green', 'Steve', 'green.steve@gmail.com', '5273697582', '09/10/1970', false),
       ('Brown', 'Ladonna', 'b.ladonna@gmail.com', '5673269756', '02/20/1985', true);

insert into interest_group(name)
values ('Soccer Fans'),
       ('Book Lovers'),
       ('Bike Racer');

insert into interest_group_member (member_number, group_number)
values ((select member_number from member where first_name = 'David'),
        (select group_number from interest_group where name = 'Soccer Fans')),
       ((select member_number from member where first_name = 'Daniel'),
        (select group_number from interest_group where name = 'Soccer Fans')),
       ((select member_number from member where last_name = 'Walter'),
        (select group_number from interest_group where name = 'Book Lovers')),
       ((select member_number from member where first_name = 'Tom'),
        (select group_number from interest_group where name = 'Book Lovers')),
       ((select member_number from member where email_address = 'green.steve@gmail.com'),
        (select group_number from interest_group where name = 'Bike Racer')),
       ((select member_number from member where phone_number = '2156798855'),
        (select group_number from interest_group where name = 'Bike Racer'));


insert into event(event_name, description, start_date_and_time, duration, event_organizer)
VALUES ('World Cup', 'Tournament', current_timestamp, 90, 'USA'),
       ('Book Reading', 'Author reads book to a crowd', '1990/01/02 10:50:00', 160, 'Hurst Public Library'),
       ('Volleyball', 'state wide tournament', '2010/11/02 09:00:00', 60, 'Texas'),
       ('Running Tournament', 'Race', '2021/01/02 10:00:00', 40, 'Lions Club');

insert into event_member(event_number, member_number)
values ((select event_number from event where event_name = 'World Cup'),
        (select member_number from member where first_name = 'Daniel')),
       ((select event_number from event where event_name = 'Book Reading'),
        (select member_number from member where last_name = 'Brooks')),
       ((select event_number from event where event_name = 'Volleyball'),
        (select member_number from member where email_address = 'p.bajgain@gmail.com')),
       ((select event_number from event where event_name = 'Running Tournament'),
        (select member_number from member where phone_number = '5673269756'))
;


alter table interest_group_member
    add constraint FK_igm_member_number foreign key (member_number) references member (member_number);
alter table interest_group_member
    add constraint FK_igm_group_number foreign key (group_number) references interest_group (group_number);
alter table event_member
    add constraint FK_em_member_number foreign key (member_number) references member (member_number);
alter table event_member
    add constraint FK_em_event_number foreign key (event_number) references event (event_number);

--commenting so I can do a commit for updated message

commit;