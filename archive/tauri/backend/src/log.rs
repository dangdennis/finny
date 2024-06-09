use tracing_subscriber::{filter::LevelFilter, fmt};

pub fn init_tracing() {
    fmt()
        .with_max_level(LevelFilter::DEBUG)
        .with_test_writer()
        .init();
}
