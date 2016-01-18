//
//  MusicMergeController.m
//  VidoeEdit
//
//  Created by PSJ on 7/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "MusicMergeController.h"

#define kMaxBars 1250
#define kMaxValue 5.0
#define kYLabelIncrement 1.0

@interface MusicMergeController ()

@end

@implementation MusicMergeController
{
    NSMutableArray *_values;
    NSInteger _markValue;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setValue:@"0" forKey:@"start"];
    [userdefaults synchronize];
    [_savebtn setEnabled:false];
    
    playbtnclickflag = false;
    
    _values = [NSMutableArray arrayWithCapacity:kMaxBars];
    AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_videoPathstr] options:nil];
    CMTime videoDuration = videoAsset.duration;
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:_audiopathstr] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    int bar_count;
    if(audioDurationSeconds<videoDurationSeconds)
        bar_count = 119;
    else
        bar_count = (int)((audioDurationSeconds/videoDurationSeconds)*119)+1;
    NSLog(@"test=%d", bar_count);
    for (NSInteger i = 0; i < bar_count; i++) {
        NSInteger val = arc4random_uniform(kMaxValue);
        [_values addObject:[NSNumber numberWithInteger:val]];
    }
  
    _barChart.maxValue = kMaxValue;
    _barChart.markValue = 60.0;
    _barChart.defaultColor = [UIColor redColor];
    _barChart.barLabelProportion = 0.80;
    _barChart.dataSource = self;
    _barChart.delegate = self;
    _barChart.parentController = self;
    [self.view addSubview:_barChart];
    
    self.movieController = [[MPMoviePlayerController alloc] init];
    [self.movieController.view setFrame:CGRectMake ( 0, 0, self.videoview.frame.size.width , self.videoview.frame.size.height)];
    [self.movieController setContentURL:[NSURL fileURLWithPath:_videoPathstr]];
    [self.videoview addSubview:self.movieController.view];
    [self.movieController play];
    
    NSURL *videoFileUrl = [NSURL fileURLWithPath:self.videoPathstr];
    self.mySAVideoRangeSlider = [[VideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, self.slideview.frame.size.width, self.slideview.frame.size.height) videoUrl:videoFileUrl ];
    
    [self.slideview addSubview:self.mySAVideoRangeSlider];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)elaborarComposicao:(NSURL *)pathVideo path:(NSURL*)pathAudio
{
    //localizar os arquivos de audio e video
    
    
    AVURLAsset *urlAudio = [[AVURLAsset alloc] initWithURL:pathAudio options:nil];
    AVURLAsset *urlVideo = [[AVURLAsset alloc] initWithURL:pathVideo options:nil];
    
    CMTime videoDuration = urlVideo.duration;
    float videoDurationSeconds = CMTimeGetSeconds(videoDuration);
    NSLog(@"vidoepath=%f",videoDurationSeconds);
    
    CMTime videotime = CMTimeMakeWithSeconds(videoDurationSeconds-0.2, videoDuration.timescale);
    
    //composition vazia
    AVMutableComposition *composicao = [AVMutableComposition composition];
    
    //trilha de audio
    AVMutableCompositionTrack *trilhaAudio = [composicao addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //quando nao quiser identificar a track passa o kCMPersistentTrackID_Invalid como parametro
    
    //criando o asset track
    AVAssetTrack *audioTrack = [[urlAudio tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    //inserttime range momento da muscia onde vou comecar a inserir na composicao
    //offtrack e a trilha da musica que queremos adicionar a essa trilha da composicao
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    int startindex = [[userdefaults objectForKey:@"start"]intValue];
    NSLog(@"test=%f", (startindex*CMTimeGetSeconds(urlVideo.duration)/119));
    float start_point = (startindex*CMTimeGetSeconds(urlVideo.duration)/119);
    [trilhaAudio insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(start_point, 600), videotime) ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    
    //trilha de video
    AVMutableCompositionTrack *trilhaVideo = [composicao addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //neste momento que esrtou pegando apenas as imagens do video descartando o audio
    AVAssetTrack *videoTrack = [[urlVideo  tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //cmtimemake -> divide o primeiro valor pelo segundo parater como resultado o tempo em segfundos para a insercao na composicao
    [trilhaVideo insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0.2, videoDuration.timescale), videotime) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    
    //efetivamente criar uma composicao e exportar para um arquivo de video
    
    //definir onde sera salvo o arquivo
    NSString *pathArquivoExportado = [NSHomeDirectory() stringByAppendingString:@"/Documents/videoExportado.mp4"];
    
    //verificando se o arquivo ja existe na pasta indicada pela string acima
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathArquivoExportado])
    {
        //apagar o arquivo anterior antes de friar um novo
        [[NSFileManager defaultManager] removeItemAtPath:pathArquivoExportado error:nil];
    }
    
    //estou inicializando o exportador com a composicao que criamos
    exportador = [[AVAssetExportSession alloc] initWithAsset:composicao presetName:AVAssetExportPresetPassthrough];
    
    //passar para o exportador onde sera salvo o arquivo
    exportador.outputURL = [NSURL fileURLWithPath:pathArquivoExportado];
    
    //passar p/o exportador qual o formato do arquivo
    exportador.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exportador exportAsynchronouslyWithCompletionHandler:^{
        //ao final do processo de criacao do video, vamos executá-lo
        NSLog(@"finish=%@", pathArquivoExportado);
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.movieController setContentURL:[NSURL fileURLWithPath:pathArquivoExportado]];
            [self.movieController play];
        });
        
    }];
}


- (IBAction)playbtnclick:(id)sender
{
    [_savebtn setEnabled:true];
    playbtnclickflag = true;
    [self elaborarComposicao:[NSURL fileURLWithPath:_videoPathstr] path:[NSURL fileURLWithPath:_audiopathstr]];
}

- (IBAction)savebtnclick:(id)sender
{
    if([[NSFileManager defaultManager] fileExistsAtPath:_videoPathstr])
         [[NSFileManager defaultManager] removeItemAtPath:_videoPathstr error:nil];
    
     NSString *sourceurl = [NSHomeDirectory() stringByAppendingString:@"/Documents/videoExportado.mp4"];
    if ([[NSFileManager defaultManager] isReadableFileAtPath:sourceurl] )
    {
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:sourceurl] toURL:[NSURL fileURLWithPath:_videoPathstr] error:nil];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"saved video successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void) buttonfalse
{
    [_playbtn setEnabled:false];
    [_savebtn setEnabled:false];
}

- (void) buttontrue
{
    [_playbtn setEnabled:true];
}

- (IBAction)backbtnclick:(id)sender
{
    [self.movieController stop];
    NSString *pathArquivoExportado = [NSHomeDirectory() stringByAppendingString:@"/Documents/othervideoExportado.mp4"];
    if([[NSFileManager defaultManager] fileExistsAtPath:pathArquivoExportado])
        [[NSFileManager defaultManager] removeItemAtPath:pathArquivoExportado error:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MRBarGraphDataSource implementation
- (NSInteger)numberOfBarsInChart:(MRBarChart *)chart {
    return _values.count;
}

- (CGFloat)barChart:(MRBarChart *)chart valueForBarAtIndex:(NSInteger)index {
    return [[_values objectAtIndex:index] floatValue];
}

- (UIColor *)barChart:(MRBarChart *)chart colorForBarAtIndex:(NSInteger)index {
    return [UIColor redColor];
    
}

@end
