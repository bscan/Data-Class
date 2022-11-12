requires 'perl', '5.020001';
requires 'Keyword::Simple', '0.04';
requires 'Sentinel', '0.06'; 
requires 'Sub::Util', '1.63';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Object::Pad', '0.71';
    requires 'Moo', '2.005004';
};

