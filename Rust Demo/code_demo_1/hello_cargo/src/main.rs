use std::io;

fn main() {
    println!("guess!");

    println!("Guess a number!");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess).expect("can not read line");

    println!("What you guess is : {}", guess);
}
