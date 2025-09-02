import AVFoundation

class Audio{
    private var audioPlayer: AVAudioPlayer?
    
    func playIntroSound() {
        if let soundURL = Bundle.main.url(forResource: "NiceSound", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.volume = 0.3 
                audioPlayer?.play()
            } catch {
                print("fehler beim Laden der audiodatei: \(error)")
            }
        }
    }
}



